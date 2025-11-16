document.addEventListener("DOMContentLoaded", () => {
    console.log("main.js loaded for page:", window.location.pathname);

    if (window.location.pathname.includes("dangnhap") || window.location.pathname.includes("login")) {
        console.log("Login page script active");

        window.showTab = function(tabName, evt) {
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(c => c.classList.remove('active'));

            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach(b => b.classList.remove('active'));

            document.getElementById(tabName).classList.add('active');
            evt.currentTarget.classList.add('active');
        };
    }
});
