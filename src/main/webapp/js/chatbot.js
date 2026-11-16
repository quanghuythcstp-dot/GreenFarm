/* ============================================================
   GreenFarm Shopping Assistant Chatbot
   Communicates with ChatServlet at POST /chat
   ============================================================ */

(function () {
    'use strict';

    // ── DOM references (assigned after DOMContentLoaded) ────────────
    let toggle, window_, messages, input, sendBtn, typing;

    // ── Context path injected from chatbot.jsp ───────────────────────
    function contextPath() {
        return (typeof window.CHAT_CONTEXT_PATH === 'string')
            ? window.CHAT_CONTEXT_PATH
            : '';
    }

    function chatEndpoint() {
        return contextPath() + '/chat';
    }

    // ── Initialisation ───────────────────────────────────────────────
    document.addEventListener('DOMContentLoaded', function () {
        toggle   = document.getElementById('chatbot-toggle');
        window_  = document.getElementById('chatbot-window');
        messages = document.getElementById('chatbot-messages');
        input    = document.getElementById('chatbot-input');
        sendBtn  = document.getElementById('chatbot-send');
        typing   = document.getElementById('chatbot-typing');

        toggle.addEventListener('click', toggleChat);
        document.getElementById('chatbot-close').addEventListener('click', closeChat);
        sendBtn.addEventListener('click', sendMessage);

        input.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        input.addEventListener('input', function () {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 100) + 'px';
        });
    });

    // ── Open / close ─────────────────────────────────────────────────
    function toggleChat() {
        window_.classList.contains('chatbot-open') ? closeChat() : openChat();
    }

    function openChat() {
        window_.classList.add('chatbot-open');
        toggle.innerHTML = '<i class="bi bi-x-lg"></i>';
        input.focus();
        scrollToBottom();
    }

    function closeChat() {
        window_.classList.remove('chatbot-open');
        toggle.innerHTML = '<i class="bi bi-chat-dots-fill"></i>';
    }

    // ── Message rendering ─────────────────────────────────────────────

    function appendUserMessage(text) {
        var el = document.createElement('div');
        el.className = 'chatbot-msg chatbot-msg-user';
        el.textContent = text;
        messages.appendChild(el);
        scrollToBottom();
    }

    // Renders the text reply and, if products is non-empty, a product card grid.
    function appendBotResponse(replyText, products) {
        hideTyping();

        // Text bubble
        var textEl = document.createElement('div');
        textEl.className = 'chatbot-msg chatbot-msg-bot';
        textEl.textContent = replyText;
        messages.appendChild(textEl);

        // Product cards
        if (products && products.length > 0) {
            var grid = document.createElement('div');
            grid.className = 'chatbot-product-grid';

            products.forEach(function (p) {
                var card = buildProductCard(p);
                grid.appendChild(card);
            });

            messages.appendChild(grid);
        }

        scrollToBottom();
    }

    function buildProductCard(p) {
        var card = document.createElement('div');
        card.className = 'chatbot-product-card';

        var imgSrc = p.image
            ? contextPath() + '/images/' + p.image
            : contextPath() + '/images/default.jpg';

        var price = typeof p.price === 'number'
            ? '$' + p.price.toFixed(2)
            : '';

        var viewUrl = contextPath() + '/product?productId=' + p.id;

        card.innerHTML =
            '<img src="' + escHtml(imgSrc) + '" alt="' + escHtml(p.name) + '" '
            + 'onerror="this.src=\'' + contextPath() + '/images/default.jpg\'">'
            + '<div class="chatbot-product-card-body">'
            +   '<div class="chatbot-product-name">' + escHtml(p.name) + '</div>'
            +   '<div class="chatbot-product-price">' + price + '</div>'
            +   '<a href="' + escHtml(viewUrl) + '" class="chatbot-product-btn">View</a>'
            + '</div>';

        return card;
    }

    function showTyping() {
        typing.style.display = 'flex';
        scrollToBottom();
    }

    function hideTyping() {
        typing.style.display = 'none';
    }

    function scrollToBottom() {
        setTimeout(function () {
            messages.scrollTop = messages.scrollHeight;
        }, 0);
    }

    // ── Send logic ────────────────────────────────────────────────────
    function sendMessage() {
        var text = input.value.trim();
        if (!text || sendBtn.disabled) return;

        appendUserMessage(text);
        input.value = '';
        input.style.height = 'auto';

        sendBtn.disabled = true;
        input.disabled   = true;
        showTyping();

        var body = new URLSearchParams();
        body.append('message', text);

        fetch(chatEndpoint(), {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        })
        .then(function (res) {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(function (data) {
            var reply    = (data && data.reply) ? data.reply : 'Sorry, I could not understand the response.';
            var products = (data && Array.isArray(data.products)) ? data.products : [];
            appendBotResponse(reply, products);
        })
        .catch(function () {
            appendBotResponse('Sorry, the assistant is temporarily unavailable.', []);
        })
        .finally(function () {
            sendBtn.disabled = false;
            input.disabled   = false;
            input.focus();
        });
    }

    // ── Utility ───────────────────────────────────────────────────────
    function escHtml(str) {
        return String(str)
            .replace(/&/g,  '&amp;')
            .replace(/</g,  '&lt;')
            .replace(/>/g,  '&gt;')
            .replace(/"/g,  '&quot;')
            .replace(/'/g,  '&#39;');
    }

}());
