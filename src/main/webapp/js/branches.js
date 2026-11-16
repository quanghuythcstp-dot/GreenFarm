/* ============================================================
   GreenFarm — Branches / Store Locator
   Handles: map switching, active card highlight, smooth scroll
   ============================================================ */

(function () {
    'use strict';

    var mapFrame   = null;   // the <iframe> element
    var allCards   = [];     // all .br-store-card elements

    document.addEventListener('DOMContentLoaded', function () {
        mapFrame = document.getElementById('branchMap');
        allCards = Array.from(document.querySelectorAll('.br-store-card'));

        // Wire each "View on Map" button
        document.querySelectorAll('.br-view-map-btn').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                var embedUrl = this.dataset.embed;
                var index    = parseInt(this.dataset.index, 10);

                if (mapFrame && embedUrl) {
                    // Fade out, swap src, fade in
                    mapFrame.style.opacity = '0';
                    setTimeout(function () {
                        mapFrame.src = embedUrl;
                        mapFrame.style.opacity = '1';
                    }, 220);
                }

                // Highlight the active card
                allCards.forEach(function (c) { c.classList.remove('active-branch'); });
                if (!isNaN(index) && allCards[index]) {
                    allCards[index].classList.add('active-branch');
                }

                // Smooth scroll to map section
                var mapSection = document.getElementById('mapSection');
                if (mapSection) {
                    mapSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            });
        });

        // Counter animation for statistics
        document.querySelectorAll('[data-count]').forEach(function (el) {
            animateCounter(el);
        });
    });

    // Simple counter animation
    function animateCounter(el) {
        var target   = parseInt(el.dataset.count, 10);
        var suffix   = el.dataset.suffix || '';
        var duration = 1600;
        var start    = null;

        function step(timestamp) {
            if (!start) start = timestamp;
            var progress = Math.min((timestamp - start) / duration, 1);
            var eased    = 1 - Math.pow(1 - progress, 3);  // ease-out cubic
            el.textContent = Math.floor(eased * target).toLocaleString() + suffix;
            if (progress < 1) requestAnimationFrame(step);
        }

        // Only run when the element is visible
        var observer = new IntersectionObserver(function (entries) {
            if (entries[0].isIntersecting) {
                requestAnimationFrame(step);
                observer.disconnect();
            }
        }, { threshold: 0.4 });

        observer.observe(el);
    }

}());
