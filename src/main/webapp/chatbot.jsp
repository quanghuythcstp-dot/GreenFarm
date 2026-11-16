<%-- Floating AI chatbot fragment — included at the end of every customer page.
     Requires Bootstrap Icons and Bootstrap JS to already be loaded by the host page. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Pass the servlet context path to JavaScript --%>
<script>
    window.CHAT_CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chatbot.css">

<%-- ── Floating toggle button ── --%>
<button id="chatbot-toggle" aria-label="Open AI chat assistant">
    <i class="bi bi-chat-dots-fill"></i>
</button>

<%-- ── Chat window ── --%>
<div id="chatbot-window" role="dialog" aria-label="AI Assistant">

    <%-- Header --%>
    <div id="chatbot-header">
        <i class="bi bi-leaf-fill fs-5"></i>
        <div class="flex-grow-1">
            <div class="chatbot-title">AI Assistant</div>
            <div class="chatbot-subtitle">GreenFarm Smart Support</div>
        </div>
        <button id="chatbot-close" aria-label="Close chat">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>

    <%-- Messages body --%>
    <div id="chatbot-messages">
        <%-- Welcome message shown on first open --%>
        <div class="chatbot-msg chatbot-msg-bot">
            Hello! I'm GreenFarm's AI assistant. How can I help you today?
        </div>

        <%-- Typing indicator — hidden until a reply is pending --%>
        <div id="chatbot-typing" style="display: none;">
            <span></span><span></span><span></span>
        </div>
    </div>

    <%-- Footer input area --%>
    <div id="chatbot-footer">
        <textarea id="chatbot-input"
                  placeholder="Type a message… (Enter to send, Shift+Enter for newline)"
                  rows="1"
                  aria-label="Chat message input"
                  autocomplete="off"></textarea>
        <button id="chatbot-send" aria-label="Send message">
            <i class="bi bi-send-fill"></i>
        </button>
    </div>

</div>

<script src="${pageContext.request.contextPath}/js/chatbot.js"></script>
