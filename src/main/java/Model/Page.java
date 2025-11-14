package Model;

import java.util.List;

public class Page <T>{
    private List<T> data;
    private int currentPage;
    private int totalPage;
    private int totalItems;
    public Page() {
    }
    public Page(List<T> data, int currentPage, int pageSize, int totalItems) {
        this.data = data;
        this.currentPage = currentPage > 0 ? currentPage : 1;
        this.totalItems = totalItems;
        this.totalPage = (int) Math.ceil((double) totalItems / (double) pageSize);
    }

    public List<T> getData() {
        return data;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public int getTotalItems() {
        return totalItems;
    }
}
