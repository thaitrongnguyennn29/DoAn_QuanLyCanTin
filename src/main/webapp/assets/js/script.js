document.addEventListener("DOMContentLoaded", () => {
    console.log("main.js loaded for page:", window.location.pathname);

    // Lấy đường dẫn gốc từ biến toàn cục (đã khai báo ở Footer)
    const contextPath = window.contextPath || "";

    // -------------------------
    // 1. TRANG ĐĂNG NHẬP
    // -------------------------
    if (window.location.pathname.includes("dangnhap") ||
        window.location.pathname.includes("dangky") || // Thêm check dangky
        window.location.pathname.includes("login")) {

        console.log("Login page script active");

        window.showTab = function(tabName, evt) {
            // 1. Ẩn/Hiện tab content
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(c => c.classList.remove('active'));

            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach(b => b.classList.remove('active'));

            const targetTab = document.getElementById(tabName);
            if (targetTab) targetTab.classList.add('active');

            // 2. Active nút bấm
            if (evt && evt.currentTarget) {
                evt.currentTarget.classList.add('active');
            } else {
                // Fallback nếu gọi hàm tự động
                if (tabName === 'login') document.getElementById('tabLogin')?.classList.add('active');
                if (tabName === 'register') document.getElementById('tabRegister')?.classList.add('active');
            }

            // 3.Thay đổi URL mà không reload trang
            if (tabName === 'register') {
                // Đổi URL thành .../dangky
                window.history.pushState({path: 'dangky'}, '', 'dangky');
            } else {
                // Đổi URL thành .../dangnhap
                window.history.pushState({path: 'dangnhap'}, '', 'dangnhap');
            }
        };

        // B. Logic tự động chuyển Tab dựa trên dữ liệu Server trả về
        const activeTabInput = document.getElementById('serverActiveTab');
        if (activeTabInput) {
            const activeTabValue = activeTabInput.value;

            if (activeTabValue === 'register') {
                // Kích hoạt tab đăng ký
                // Cách 1: Giả lập click (sẽ kích hoạt hàm showTab ở trên)
                const regBtn = document.getElementById('tabRegister');
                if (regBtn) regBtn.click();
            } else {
                // Mặc định là login
                const loginBtn = document.getElementById('tabLogin');
                if (loginBtn) loginBtn.click();
            }
        }
    }

    // -------------------------
    // 2. TRANG THỰC ĐƠN (MENU)
    // -------------------------
    else if (window.location.pathname.includes("thucdon")) {
        console.log("Menu page script active");

        // A. Logic Lọc món ăn (Filter)
        const filterBtns = document.querySelectorAll(".filter-btn");
        const items = document.querySelectorAll(".menu-card-item");

        filterBtns.forEach(btn => {
            btn.addEventListener("click", function(e) {
                e.preventDefault();
                const filter = this.dataset.filter;

                filterBtns.forEach(b => b.classList.remove("active"));
                this.classList.add("active");

                items.forEach(item => {
                    if (filter === "all" || item.dataset.category === filter) {
                        item.style.display = "block";
                    } else {
                        item.style.display = "none";
                    }
                });
            });
        });

        // B. Logic Thêm vào giỏ hàng (ĐÃ CHỈNH SỬA LOGIC ĐẾM)
        // B. Logic Thêm vào giỏ hàng (BẢN FULL: KHÓA NÚT + HIỆU ỨNG ICON)
        document.querySelectorAll('.btn-add-cart').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();

                // 1. Khóa nút ngay lập tức để chống spam click
                this.disabled = true;

                const originalText = this.innerHTML;
                const maMon = this.dataset.mamon;

                fetch(contextPath + '/giohang', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=add&maMon=' + maMon
                })
                .then(response => {
                    if (response.ok) {
                        return response.text().then(newCount => {

                            // --- CẬP NHẬT ICON GIỎ HÀNG (Đã thêm lại) ---
                            const cartBadge = document.querySelector('.cart-badge');
                            if (cartBadge) {
                                // Cập nhật số lượng
                                cartBadge.textContent = newCount;

                                // Hiệu ứng rung icon (Đoạn này bị thiếu ở code trước)
                                const cartIcon = document.querySelector('.cart');
                                if(cartIcon) {
                                    cartIcon.style.transform = "scale(1.2)";
                                    setTimeout(() => cartIcon.style.transform = "scale(1)", 200);
                                }
                            }

                            // --- HIỆU ỨNG NÚT THÀNH CÔNG ---
                            this.innerHTML = '<i class="bi bi-check2"></i> Xong';
                            this.classList.remove('btn-primary');
                            this.classList.add('btn-success');

                            // Đảm bảo nút vẫn bị khóa khi hiện chữ Xong
                            this.disabled = true;

                            // Sau 1 giây thì trả lại trạng thái ban đầu
                            setTimeout(() => {
                                this.innerHTML = originalText;

                                // Mở khóa lại nút để mua tiếp
                                this.disabled = false;

                                this.classList.remove('btn-success');
                                this.classList.add('btn-outline-primary');
                                this.style.width = '';
                            }, 1000);
                        });
                    } else {
                        throw new Error('Server response not ok');
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                    alert("Có lỗi kết nối, vui lòng thử lại!");
                    this.innerHTML = originalText;

                    // Mở lại nút nếu gặp lỗi
                    this.disabled = false;
                    this.style.width = '';
                });
            });
        });
    }

    // -------------------------
    // 3. TRANG GIỎ HÀNG
    // -------------------------
    else if (window.location.pathname.includes("giohang") ||
        window.location.pathname.includes("cart")) {

        console.log("Cart page script active");

        // --- HELPER FUNCTIONS ---
        const formatCurrency = (amount) => {
            return amount.toLocaleString('vi-VN') + 'đ';
        };

        const parseCurrency = (str) => {
            return parseFloat(str.replace(/[^\d]/g, ''));
        };

        const updateSummary = () => {
            let subtotal = 0;
            document.querySelectorAll('.cart-item').forEach(item => {
                const priceText = item.querySelector('.cart-item-price').textContent;
                subtotal += parseCurrency(priceText);
            });

            let discount = 0;
            const discountEl = document.querySelector('.order-summary .text-success');
            if (discountEl) {
                discount = parseCurrency(discountEl.textContent);
            }

            const total = subtotal - discount;
            const summaryValues = document.querySelectorAll('.order-summary .summary-value');
            if (summaryValues.length > 0) {
                summaryValues[0].textContent = formatCurrency(subtotal);
            }

            const totalEl = document.querySelector('.summary-total .summary-value');
            if (totalEl) {
                totalEl.textContent = formatCurrency(total > 0 ? total : 0);
            }
        };

        // --- EVENTS: THAY ĐỔI SỐ LƯỢNG ---
        document.querySelectorAll('.qty-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const maMon = this.dataset.mamon;
                const control = this.closest('.quantity-control');
                const input = control.querySelector('.qty-input');
                let val = parseInt(input.value);

                if (this.classList.contains('plus')) val++;
                else if (this.classList.contains('minus') && val > 1) val--;
                else return;

                control.querySelectorAll('.qty-btn').forEach(b => b.disabled = true);
                input.value = val;

                const cartItem = this.closest('.cart-item');
                const priceEl = cartItem.querySelector('.cart-item-price');
                const unitPrice = parseCurrency(cartItem.querySelector('.text-muted').textContent);

                priceEl.textContent = formatCurrency(unitPrice * val);

                fetch(contextPath + '/giohang', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=update&maMon=' + maMon + '&quantity=' + val
                }).then(() => {
                    updateSummary();
                    control.querySelectorAll('.qty-btn').forEach(b => b.disabled = false);
                }).catch((err) => {
                    console.error(err);
                    location.reload();
                });
            });
        });

        // --- EVENTS: XÓA MÓN ---
        document.querySelectorAll('.btn-remove').forEach(btn => {
            btn.addEventListener('click', function() {
                const maMon = this.dataset.mamon;
                const cartItem = this.closest('.cart-item');

                fetch(contextPath + '/giohang', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=remove&maMon=' + maMon
                }).then(() => {
                    cartItem.remove();
                    updateSummary();
                    const remaining = document.querySelectorAll('.cart-item').length;
                    const subtitle = document.querySelector('.section-subtitle');
                    if (subtitle) subtitle.textContent = 'Bạn có ' + remaining + ' món trong giỏ hàng';
                    if (remaining === 0) location.reload();
                }).catch(err => console.error('Lỗi khi xóa:', err));
            });
        });
    }

        // -------------------------
        // 4. CÁC TRANG KHÁC
    // -------------------------
    else {
        console.log("No specific script for:", window.location.pathname);
    }
});