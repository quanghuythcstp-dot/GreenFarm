package controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Properties;
import model.Customer;

@WebServlet("/auth/google/callback")
public class GoogleCallbackServlet extends HttpServlet {

    private static final String TOKEN_URL   = "https://oauth2.googleapis.com/token";
    private static final String PROFILE_URL = "https://www.googleapis.com/oauth2/v3/userinfo";

    private final CustomerDAO  customerDAO  = new CustomerDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final HttpClient   httpClient   = HttpClient.newBuilder()
                                                    .connectTimeout(Duration.ofSeconds(10))
                                                    .build();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        String code         = request.getParameter("code");
        String state        = request.getParameter("state");
        String errorParam   = request.getParameter("error");
        String sessionState = (String) session.getAttribute("oauth_state");

        // User denied access
        if (errorParam != null) {
            response.sendRedirect(request.getContextPath() + "/login?error=google_denied");
            return;
        }

        // CSRF check
        if (code == null || state == null || !state.equals(sessionState)) {
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_state");
            return;
        }
        session.removeAttribute("oauth_state");

        Properties props   = loadConfig(request);
        String clientId    = props.getProperty("google.client.id");
        String clientSecret = props.getProperty("google.client.secret");
        String redirectUri = props.getProperty("google.redirect.uri");

        try {
            // Step 1: Exchange code for access token
            String accessToken = exchangeCodeForToken(code, clientId, clientSecret, redirectUri);
            if (accessToken == null) {
                forwardError(request, response, "Failed to authenticate with Google.");
                return;
            }

            // Step 2: Fetch Google profile
            JsonNode profile = fetchProfile(accessToken);
            if (profile == null) {
                forwardError(request, response, "Failed to retrieve Google profile.");
                return;
            }

            String email    = profile.path("email").asText();
            String fullName = profile.path("name").asText();

            if (email == null || email.isEmpty()) {
                forwardError(request, response, "Google account did not provide an email.");
                return;
            }

            // Step 3: Find or create customer
            Customer customer = customerDAO.findByEmail(email);
            if (customer == null) {
                customer = customerDAO.registerGoogleUser(email, fullName);
            }

            if (customer == null) {
                forwardError(request, response, "Could not create account. Please try again.");
                return;
            }

            // Step 4: Login — same session pattern as LoginServlet
            session.setAttribute("customer", customer);

            if ("admin".equalsIgnoreCase(customer.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            forwardError(request, response, "Google login was interrupted. Please try again.");
        }
    }

    // ----------------------------------------------------------------
    // Exchange authorization code for access token
    // ----------------------------------------------------------------
    private String exchangeCodeForToken(String code, String clientId,
                                         String clientSecret, String redirectUri)
            throws IOException, InterruptedException {
        String body = "code="          + encode(code)
                    + "&client_id="    + encode(clientId)
                    + "&client_secret=" + encode(clientSecret)
                    + "&redirect_uri=" + encode(redirectUri)
                    + "&grant_type=authorization_code";

        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(TOKEN_URL))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(body, StandardCharsets.UTF_8))
                .timeout(Duration.ofSeconds(10))
                .build();

        HttpResponse<String> res = httpClient.send(req, HttpResponse.BodyHandlers.ofString());
        if (res.statusCode() != 200) {
            System.out.println("Token exchange failed: " + res.body());
            return null;
        }

        JsonNode json = objectMapper.readTree(res.body());
        return json.path("access_token").asText(null);
    }

    // ----------------------------------------------------------------
    // Fetch user profile from Google using the access token
    // ----------------------------------------------------------------
    private JsonNode fetchProfile(String accessToken) throws IOException, InterruptedException {
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(PROFILE_URL))
                .header("Authorization", "Bearer " + accessToken)
                .GET()
                .timeout(Duration.ofSeconds(10))
                .build();

        HttpResponse<String> res = httpClient.send(req, HttpResponse.BodyHandlers.ofString());
        if (res.statusCode() != 200) {
            System.out.println("Profile fetch failed: " + res.body());
            return null;
        }
        return objectMapper.readTree(res.body());
    }

    // ----------------------------------------------------------------
    // Helpers
    // ----------------------------------------------------------------
    private Properties loadConfig(HttpServletRequest request) throws IOException {
        Properties props = new Properties();
        try (InputStream is = request.getServletContext()
                .getResourceAsStream("/WEB-INF/config.properties")) {
            if (is != null) props.load(is);
        }
        return props;
    }

    private String encode(String value) {
        return java.net.URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private void forwardError(HttpServletRequest request,
                               HttpServletResponse response, String msg)
            throws ServletException, IOException {
        request.setAttribute("error", msg);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
