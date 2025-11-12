document.addEventListener("DOMContentLoaded", () => {
    console.log("main.js loaded for page:", window.location.pathname);

    if (window.location.pathname.includes("login")) {
        console.log("▶️ Login page script active");

        window.showTab = function(tabName, evt) {
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(c => c.classList.remove('active'));

            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach(b => b.classList.remove('active'));

            document.getElementById(tabName).classList.add('active');
            evt.currentTarget.classList.add('active');
        };
    }


    if (window.location.pathname.includes("home") ||
        window.location.pathname.endsWith("/") ||
        window.location.pathname.includes("index")) {
        console.log("Home page script active");

        let cartCount = 0;

        window.addToCart = function() {
            cartCount++;
            const badge = document.getElementById('cartCount');
            if (!badge) return;

            badge.textContent = cartCount;

            // Hiệu ứng phóng to nhỏ khi thêm
            badge.style.transition = "transform 0.2s ease";
            badge.style.transform = 'scale(1.3)';
            setTimeout(() => {
                badge.style.transform = 'scale(1)';
            }, 200);
        };
    }

    if (window.location.pathname.includes("menu")) {
        console.log("Menu page script active");

        const filterButtons = document.querySelectorAll('.filter-btn');
        const menuItems = document.querySelectorAll('.menu-item');

        filterButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                const filter = btn.dataset.filter;

                // Active button
                filterButtons.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');

                // Lọc món ăn
                menuItems.forEach(item => {
                    if (filter === 'all' || item.dataset.category === filter) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                });
            });
        });
    }
});
