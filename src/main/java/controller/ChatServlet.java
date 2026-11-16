package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import model.Product;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {

    private final ProductDAO   productDAO   = new ProductDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    private static final int MAX_RESULTS = 6;

    // ── Entry point ──────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String raw = request.getParameter("message");
        ObjectNode json = (raw == null || raw.trim().isEmpty())
                ? buildReply("Please type a message so I can help you.", List.of())
                : processMessage(raw.trim());

        try (PrintWriter out = response.getWriter()) {
            out.print(objectMapper.writeValueAsString(json));
        }
    }

    // ── Intent routing ───────────────────────────────────────────────

    // Normalises the message then routes to the first matching intent handler.
    // Order matters: availability must be checked before name search to
    // prevent "do you have" being matched as a product name.
    private ObjectNode processMessage(String raw) {
        String msg = normalise(raw);

        ObjectNode result = detectAvailability(msg);
        if (result != null) return result;

        result = detectPrice(msg);
        if (result != null) return result;

        result = detectRecommendation(msg);
        if (result != null) return result;

        result = detectCategory(msg);
        if (result != null) return result;

        result = detectProductName(msg);
        if (result != null) return result;

        return buildReply(
                "Sorry, I can only help you search and recommend GreenFarm products.",
                List.of());
    }

    // ── Intent detectors ─────────────────────────────────────────────

    // Handles: "do you have apple?", "is tomato available?", "is milk in stock?"
    private ObjectNode detectAvailability(String msg) {
        if (!containsAny(msg, "do you have", "is", "available", "in stock", "do you sell")) {
            return null;
        }
        // Strip availability phrases to extract the product keyword
        String keyword = stripWords(msg,
                "do you have", "do you sell", "is", "are", "available", "in stock", "please");
        if (keyword.isEmpty()) return null;

        List<Product> results = productDAO.searchProducts(keyword);
        if (results.isEmpty()) {
            return buildReply("Sorry, \"" + keyword + "\" is not available in our store right now.",
                    List.of());
        }
        return buildReply("Yes! We have " + results.size() + " product(s) matching \""
                + keyword + "\".", limit(results));
    }

    // Handles: "cheap products", "affordable vegetables", "expensive fruits"
    private ObjectNode detectPrice(String msg) {
        boolean cheap     = containsAny(msg, "cheap", "cheapest", "affordable",
                                             "low price", "budget", "inexpensive");
        boolean expensive = containsAny(msg, "expensive", "high price", "priciest");
        if (!cheap && !expensive) return null;

        // Check if a category is also mentioned to narrow results
        String categoryHint = extractCategoryHint(msg);
        List<Product> results;

        if (!categoryHint.isEmpty()) {
            results = new ArrayList<>(productDAO.getProductsByCategoryName(categoryHint));
            if (cheap) {
                results.sort((a, b) -> Double.compare(a.getPrice(), b.getPrice()));
            } else {
                results.sort((a, b) -> Double.compare(b.getPrice(), a.getPrice()));
            }
        } else {
            results = productDAO.getProductsSortedByPrice(cheap);
        }

        if (results.isEmpty()) {
            return buildReply("Sorry, no products were found.", List.of());
        }
        String label = cheap ? "most affordable" : "highest-priced";
        return buildReply("Here are our " + label + " products!", limit(results));
    }

    // Handles: "recommend", "suggest", "what should I buy", "show popular"
    private ObjectNode detectRecommendation(String msg) {
        if (!containsAny(msg, "recommend", "suggestion", "suggest",
                              "what should", "popular", "show me", "best seller")) {
            return null;
        }
        List<Product> all = productDAO.getAllProducts();
        List<Product> inStock = new ArrayList<>();
        for (Product p : all) {
            if (p.getQuantity() > 0) {
                inStock.add(p);
            }
            if (inStock.size() == MAX_RESULTS) break;
        }
        if (inStock.isEmpty()) {
            return buildReply("Sorry, no products are available right now.", List.of());
        }
        return buildReply("Here are some products you might like!", inStock);
    }

    // Handles: "vegetables", "fruits", "dairy", "herbs", "grains"
    private ObjectNode detectCategory(String msg) {
        String category = extractCategoryHint(msg);
        if (category.isEmpty()) return null;

        List<Product> results = productDAO.getProductsByCategoryName(category);
        if (results.isEmpty()) {
            return buildReply("Sorry, no products were found in that category.", List.of());
        }
        return buildReply("Here are our " + category + " products ("
                + results.size() + " available).", limit(results));
    }

    // Handles direct product name search: "apple", "tomato", "organic rice"
    private ObjectNode detectProductName(String msg) {
        List<Product> results = productDAO.searchProducts(msg);
        if (results.isEmpty()) return null;

        return buildReply("I found " + results.size()
                + " product(s) matching your search.", limit(results));
    }

    // ── JSON builder ─────────────────────────────────────────────────

    private ObjectNode buildReply(String replyText, List<Product> products) {
        ObjectNode root = objectMapper.createObjectNode();
        root.put("reply", replyText);

        ArrayNode arr = root.putArray("products");
        for (Product p : products) {
            ObjectNode node = arr.addObject();
            node.put("id",    p.getProductId());
            node.put("name",  p.getProductName());
            node.put("price", p.getPrice());
            node.put("image", p.getImage() != null ? p.getImage() : "");
        }
        return root;
    }

    // ── Utilities ────────────────────────────────────────────────────

    // Lowercases and strips punctuation from raw input.
    private String normalise(String raw) {
        return raw.toLowerCase().replaceAll("[^a-z0-9\\s]", " ").trim();
    }

    private boolean containsAny(String msg, String... keywords) {
        for (String kw : keywords) {
            if (msg.contains(kw)) return true;
        }
        return false;
    }

    // Removes all given phrases from msg and returns the remainder trimmed.
    // Used to extract the product keyword from sentences like "do you have apples".
    private String stripWords(String msg, String... phrases) {
        for (String phrase : phrases) {
            msg = msg.replace(phrase, " ");
        }
        // Also remove common filler words
        msg = msg.replaceAll("\\b(a|an|the|some|any|please)\\b", " ");
        return msg.replaceAll("\\s+", " ").trim();
    }

    // Returns the first category keyword found in the message, or empty string.
    private String extractCategoryHint(String msg) {
        if (containsAny(msg, "vegetable", "veggie"))      return "vegetable";
        if (containsAny(msg, "fruit"))                    return "fruit";
        if (containsAny(msg, "herb", "herbal", "spice"))  return "herb";
        if (containsAny(msg, "grain", "cereal"))          return "grain";
        if (containsAny(msg, "dairy", "egg", "milk"))     return "dairy";
        return "";
    }

    private List<Product> limit(List<Product> list) {
        return list.size() <= MAX_RESULTS ? list : list.subList(0, MAX_RESULTS);
    }
}
