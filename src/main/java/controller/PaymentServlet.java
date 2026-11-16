package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import model.Customer;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    // ── Bank configuration — change only here ──────────────────
    private static final String BANK_CODE       = "MB";
    private static final String BANK_ACCOUNT    = "0359151256";
    private static final String BANK_NAME       = "MB Bank";
    private static final String ACCOUNT_NAME    = "TRUONG QUANG HUY";
    // ───────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Set by CheckoutServlet after successful order creation
        Object orderId    = session.getAttribute("pendingOrderId");
        Object orderTotal = session.getAttribute("pendingOrderTotal");

        if (orderId == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Transfer content: GF-{orderId}
        String transferContent = "GF-" + orderId;

        // Amount is already stored in VND — pass directly to VietQR as integer
        long amountVnd = 0;
        if (orderTotal instanceof Number) {
            amountVnd = Math.round(((Number) orderTotal).doubleValue());
        }

        // Build VietQR image URL
        // Format: https://img.vietqr.io/image/{BANK}-{ACCOUNT}-compact2.png
        //         ?amount={VND}&addInfo={TRANSFER_CONTENT}&accountName={NAME}
        String vietQrUrl = "https://img.vietqr.io/image/"
                + BANK_CODE + "-" + BANK_ACCOUNT + "-compact2.png"
                + "?amount=" + amountVnd
                + "&addInfo=" + URLEncoder.encode(transferContent, StandardCharsets.UTF_8)
                + "&accountName=" + URLEncoder.encode(ACCOUNT_NAME, StandardCharsets.UTF_8);

        request.setAttribute("orderId",         orderId);
        request.setAttribute("orderTotal",       orderTotal);
        request.setAttribute("transferContent",  transferContent);
        request.setAttribute("vietQrUrl",        vietQrUrl);
        request.setAttribute("bankCode",         BANK_CODE);
        request.setAttribute("bankName",         BANK_NAME);
        request.setAttribute("bankAccount",      BANK_ACCOUNT);
        request.setAttribute("accountName",      ACCOUNT_NAME);

        request.getRequestDispatcher("/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("pendingOrderId");
        session.removeAttribute("pendingOrderTotal");
        session.setAttribute("successMessage",
                "Thank you! Your bank transfer is being verified. Your order will be confirmed soon.");
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
