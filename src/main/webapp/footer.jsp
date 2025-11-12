<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row gy-5">
            <!-- Column 1: Brand + Description -->
            <div class="col-lg-4 col-md-6 footer-col">
                <div class="footer-brand d-flex align-items-center gap-2 mb-3">
                    <i class="bi bi-fork-knife fs-3"></i>
                    <span>NTC Canteen</span>
                </div>
                <p class="text-white-50 mb-4">
                    Điểm đến ẩm thực lý tưởng với thực đơn phong phú và phục vụ chuyên nghiệp.
                </p>
                <div class="d-flex align-items-center">
                    <a href="#" class="social-icon"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="social-icon"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="social-icon"><i class="bi bi-envelope"></i></a>
                </div>
            </div>

            <!-- Column 2: Contact + Google Map -->
            <div class="col-lg-4 col-md-6 footer-col">
                <h5 class="footer-title">Liên Hệ</h5>
                <ul class="list-unstyled text-white-50 mb-4">
                    <li class="mb-2"><i class="bi bi-geo-alt-fill me-2"></i>Đường số 24, Linh Đông, Thủ Đức, TP.HCM</li>
                    <li class="mb-2"><i class="bi bi-telephone-fill me-2"></i>0833 333 333</li>
                    <li class="mb-3"><i class="bi bi-envelope-fill me-2"></i>ntccanteen@canteen.vn</li>
                </ul>

                <!-- Google Map -->
                <div class="footer-map">
                    <iframe
                            src="https://www.google.com/maps?q=10.85190287402083,106.74018002793846&z=16&output=embed"
                            allowfullscreen=""
                            loading="lazy"
                            referrerpolicy="no-referrer-when-downgrade">
                    </iframe>
                </div>
            </div>


            <!-- Column 3: Hours + Subscribe -->
            <div class="col-lg-4 col-md-12 footer-col">
                <div class="footer-hours mb-4">
                    <h5 class="footer-title mb-3">Giờ Hoạt Động</h5>
                    <ul class="list-unstyled text-white-50 mb-0">
                        <li><i class="bi bi-clock me-2"></i>Thứ 2 - Thứ 6: 7:00 - 19:00</li>
                        <li><i class="bi bi-clock me-2"></i>Thứ 7 - CN: 8:00 - 17:00</li>
                    </ul>
                </div>

                <div class="footer-subscribe">
                    <h5 class="footer-title mb-2">Đăng Ký Nhận Tin</h5>
                    <p class="text-white-50 mb-3" style="font-size: 0.9rem;">
                        Nhận tin tức và ưu đãi mới nhất từ NTC Canteen
                    </p>
                    <form class="input-group">
                        <input type="email" class="form-control footer-input" placeholder="Nhập email của bạn">
                        <button class="btn btn-subscribe" type="button"><i class="bi bi-send"></i></button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Copyright -->
        <div class="text-center border-top pt-4 mt-5 border-white-25">
            <p class="text-white-50 mb-0">&copy; <span id="year"></span> NTC Canteen. Mang món ăn ngon đến bạn.</p>
        </div>
    </div>
</footer>

<script>
    document.getElementById("year").textContent = new Date().getFullYear();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
