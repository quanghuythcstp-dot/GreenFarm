package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.UUID;

@WebServlet("/auth/google")
public class GoogleLoginServlet extends HttpServlet {

    private static final String GOOGLE_AUTH_URL =
            "https://accounts.google.com/o/oauth2/v2/auth";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Properties props = loadConfig(request);
        String clientId   = props.getProperty("google.client.id");
        String redirectUri = props.getProperty("google.redirect.uri");

        // CSRF protection: random state stored in session, verified on callback
        String state = UUID.randomUUID().toString();
        request.getSession().setAttribute("oauth_state", state);

        String authUrl = GOOGLE_AUTH_URL
                + "?client_id="     + encode(clientId)
                + "&redirect_uri="  + encode(redirectUri)
                + "&response_type=code"
                + "&scope="         + encode("openid email profile")
                + "&state="         + encode(state)
                + "&access_type=online";

        response.sendRedirect(authUrl);
    }

    private Properties loadConfig(HttpServletRequest request) throws IOException {
        Properties props = new Properties();
        try (InputStream is = request.getServletContext()
                .getResourceAsStream("/WEB-INF/config.properties")) {
            if (is != null) props.load(is);
        }
        return props;
    }

    private String encode(String value) throws IOException {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
