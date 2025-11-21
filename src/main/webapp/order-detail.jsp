<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.DonHang" %>
<%@ page import="DTO.ChiTietDonHangDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    DonHang dh = (DonHang) request.getAttribute("donHang");
    List<ChiTietDonHangDTO> details = (List<ChiTietDonHangDTO>) request.getAttribute("details");
%>

<div class="p-2">
    <div class="d-flex justify-content-between align-items-center mb-4 bg-light p-3 rounded-3">
        <div>
            <small class="text-muted d-block text-uppercase fw-bold" style="font-size: 0.75rem;">Mã đơn hàng</small>
            <span class="fw-bold text-dark fs-5">#<%= String.format("DH%03d", dh.getMaDonHang()) %></span>
        </div>
        <div class="text-end">
            <small class="text-muted d-block" style="font-size: 0.8rem;">
                Ngày đặt: <%= dh.getNgayDat().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
            </small>
            <%
                String badgeClass = "bg-secondary";
                if("Đang xử lí".equals(dh.getTrangThai())) badgeClass = "bg-warning text-dark";
                else if("Đã hoàn thành".equals(dh.getTrangThai())) badgeClass = "bg-success";
                else if("Đã hủy".equals(dh.getTrangThai())) badgeClass = "bg-danger";
            %>
            <span class="badge <%= badgeClass %> rounded-pill mt-1"><%= dh.getTrangThai() %></span>
        </div>
    </div>

    <h6 class="fw-bold text-muted mb-3 text-uppercase" style="font-size: 0.85rem;">Danh sách món ăn</h6>

    <div class="list-group list-group-flush border rounded-3 overflow-hidden mb-3">
        <% if(details != null) { for(ChiTietDonHangDTO item : details) { %>
        <div class="list-group-item py-3">
            <div class="d-flex align-items-center gap-3">

                <img src="<%= request.getContextPath() %>/assets/images/MonAn/<%= item.getHinhAnhMonAn() %>"
                     alt="<%= item.getTenMonAn() %>"
                     style="width: 55px; height: 55px; object-fit: cover; border-radius: 8px;">

                <div class="flex-grow-1">
                    <div class="fw-bold text-dark"><%= item.getTenMonAn() %></div>
                    <div class="small text-muted">
                        <i class="bi bi-shop me-1"></i><%= item.getTenQuay() %>
                    </div>
                </div>
                <div class="text-end">
                    <div class="fw-bold text-dark"><%= String.format("%,.0f", item.getThanhTien()) %>đ</div>
                    <small class="text-muted">x<%= item.getSoLuong() %></small>
                </div>
            </div>
        </div>
        <% }} %>
    </div>

    <div class="d-flex justify-content-between align-items-center pt-3 border-top">
        <span class="fw-bold text-secondary">Tổng thanh toán</span>
        <span class="fs-4 fw-bold text-danger"><%= String.format("%,.0f", dh.getTongTien()) %>đ</span>
    </div>
</div>