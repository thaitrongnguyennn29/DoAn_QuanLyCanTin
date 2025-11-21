document.addEventListener("DOMContentLoaded", () => {
    console.log("main.js loaded for page:", window.location.pathname);

    // Lấy đường dẫn gốc từ biến toàn cục (đã khai báo ở Footer)
    const contextPath = window.contextPath || "";

    // ============================================================
    // 0. XỬ LÝ POPUP THÔNG BÁO (SWEETALERT2)
    // ============================================================
    if (window.sessionSuccessMessage && window.sessionSuccessMessage.trim() !== "") {
        if (typeof Swal !== 'undefined') {
            Swal.fire({
                title: 'Thành công!',
                text: window.sessionSuccessMessage,
                icon: 'success',
                iconColor: '#005C97',
                confirmButtonText: 'Tuyệt vời',
                confirmButtonColor: '#005C97',
                timer: 5000,
                timerProgressBar: true
            });
        } else {
            alert(window.sessionSuccessMessage);
        }
        window.sessionSuccessMessage = null;
    }

    // ============================================================
    // 1. TRANG ĐĂNG NHẬP (LOGIN / REGISTER)
    // ============================================================
    if (window.location.pathname.includes("dangnhap") ||
        window.location.pathname.includes("dangky") ||
        window.location.pathname.includes("login")) {

        console.log("Login page script active");

        window.showTab = function(tabName, evt) {
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(c => c.classList.remove('active'));

            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach(b => b.classList.remove('active'));

            const targetTab = document.getElementById(tabName);
            if (targetTab) targetTab.classList.add('active');

            if (evt && evt.currentTarget) {
                evt.currentTarget.classList.add('active');
            } else {
                if (tabName === 'login') document.getElementById('tabLogin')?.classList.add('active');
                if (tabName === 'register') document.getElementById('tabRegister')?.classList.add('active');
            }

            if (tabName === 'register') {
                window.history.replaceState({path: 'dangky'}, '', 'dangky'); // <-- DÒNG MỚI
            } else {
                window.history.replaceState({path: 'dangnhap'}, '', 'dangnhap'); // <-- DÒNG MỚI
            }
        };

        const activeTabInput = document.getElementById('serverActiveTab');
        if (activeTabInput) {
            const activeTabValue = activeTabInput.value;
            if (activeTabValue === 'register') {
                const regBtn = document.getElementById('tabRegister');
                if (regBtn) regBtn.click();
            } else {
                const loginBtn = document.getElementById('tabLogin');
                if (loginBtn) loginBtn.click();
            }
        }
    }

    // ============================================================
    // 2. TRANG THỰC ĐƠN (MENU)
    // ============================================================
    else if (window.location.pathname.includes("thucdon")) {
        console.log("Menu page script active");

        // A. Logic Lọc món ăn
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

        // B. Logic Thêm vào giỏ hàng
        document.querySelectorAll('.btn-add-cart').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
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
                                const cartBadge = document.querySelector('.cart-badge');
                                if (cartBadge) {
                                    cartBadge.textContent = newCount;
                                    const cartIcon = document.querySelector('.cart');
                                    if(cartIcon) {
                                        cartIcon.style.transform = "scale(1.2)";
                                        setTimeout(() => cartIcon.style.transform = "scale(1)", 200);
                                    }
                                }
                                this.innerHTML = '<i class="bi bi-check2"></i> Xong';
                                this.classList.remove('btn-primary', 'btn-outline-primary');
                                this.classList.add('btn-success');
                                setTimeout(() => {
                                    this.innerHTML = originalText;
                                    this.disabled = false;
                                    this.classList.remove('btn-success');
                                    this.classList.add('btn-outline-primary');
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
                        this.disabled = false;
                    });
            });
        });
    }

    // ============================================================
    // 3. TRANG GIỎ HÀNG (CART)
    // ============================================================
    else if (window.location.pathname.includes("giohang") ||
        window.location.pathname.includes("cart") ||
        window.location.pathname.includes("kiemtradonhang")) {

        console.log("Cart page script active");

        const formatCurrency = (amount) => amount.toLocaleString('vi-VN') + 'đ';
        const parseCurrency = (str) => parseFloat(str.replace(/[^\d]/g, ''));

        const updateSummary = () => {
            let subtotal = 0;
            document.querySelectorAll('.cart-item').forEach(item => {
                const priceText = item.querySelector('.cart-item-price').textContent;
                subtotal += parseCurrency(priceText);
            });
            let discount = 0;
            const discountEl = document.querySelector('.order-summary .text-success');
            if (discountEl) discount = parseCurrency(discountEl.textContent);
            const total = subtotal - discount;

            const summaryValues = document.querySelectorAll('.order-summary .summary-value');
            if (summaryValues.length > 0) summaryValues[0].textContent = formatCurrency(subtotal);

            const totalEl = document.querySelector('.summary-total .summary-value');
            if (totalEl) totalEl.textContent = formatCurrency(total > 0 ? total : 0);
        };

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

    // ============================================================
    // 5. TRANG QUẢN LÝ ĐƠN HÀNG (MY ORDER) - MỚI THÊM
    // ============================================================
    // Kiểm tra xem có element Tabs đơn hàng không để chạy logic này
    else if (document.getElementById('orderTabs')) {
        console.log("Order Management page script active");

        // --- A. GIỮ NGUYÊN TAB KHI F5 ---
        var savedTab = localStorage.getItem('activeOrderTab');
        if (savedTab) {
            var tabTrigger = document.getElementById(savedTab);
            if (tabTrigger) {
                var tabInstance = new bootstrap.Tab(tabTrigger);
                tabInstance.show();
            }
        }
        var tabEls = document.querySelectorAll('button[data-bs-toggle="tab"]');
        tabEls.forEach(function(tabEl) {
            tabEl.addEventListener('shown.bs.tab', function (event) {
                localStorage.setItem('activeOrderTab', event.target.id);
            });
        });

        // --- B. TỰ ĐỘNG MỞ MODAL KHI F5 (Biến global từ Footer) ---
        if (window.autoOpenModal) {
            const modalEl = document.getElementById('orderDetailModal');
            if(modalEl) {
                var myModal = new bootstrap.Modal(modalEl);
                myModal.show();
            }
        }

        // --- C. XỬ LÝ URL KHI ĐÓNG MODAL ---
        var myModalEl = document.getElementById('orderDetailModal');
        if (myModalEl) {
            myModalEl.addEventListener('hidden.bs.modal', function (event) {
                var currentUrl = window.location.href;
                if(currentUrl.includes('chitiet-donhang')) {
                    const backUrl = contextPath ? contextPath + "/donhang-cuatoi" : "donhang-cuatoi";
                    window.history.pushState({page: "list"}, "Danh sách đơn hàng", backUrl);
                }
            });
        }
    }

    // ============================================================
    // 6. CÁC TRANG KHÁC
    // ============================================================
    else {
        console.log("No specific script for:", window.location.pathname);
    }
});


// ============================================================
// HÀM GLOBAL (Nằm ngoài DOMContentLoaded để HTML gọi được)
// ============================================================
window.viewOrderDetail = function(orderId) {
    // Lấy contextPath (Nếu hàm này chạy thì DOM đã load xong, biến contextPath ở footer đã có)
    const ctx = window.contextPath || "";

    const modalEl = document.getElementById('orderDetailModal');
    if (!modalEl) return;

    // 1. Mở Modal
    var myModal = new bootstrap.Modal(modalEl);
    myModal.show();

    // 2. Đổi URL
    const detailUrl = (ctx ? ctx + "/" : "") + "chitiet-donhang?id=" + orderId;
    window.history.pushState({page: "detail"}, "Chi tiết đơn hàng", detailUrl);

    // 3. Loading
    const contentEl = document.getElementById('modalContent');
    if(contentEl) {
        contentEl.innerHTML = '<div class="text-center py-5"><div class="spinner-border text-primary"></div><p class="mt-2 text-muted">Đang tải dữ liệu...</p></div>';
    }

    // 4. Ajax
    fetch((ctx ? ctx + "/" : "") + 'chitiet-donhang?id=' + orderId, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
        .then(response => {
            if (!response.ok) throw new Error("Network response was not ok");
            return response.text();
        })
        .then(html => {
            if(contentEl) contentEl.innerHTML = html;
        })
        .catch(error => {
            console.error('Error:', error);
            if(contentEl) contentEl.innerHTML = '<div class="text-center text-danger py-4">Có lỗi xảy ra.</div>';
        });
};