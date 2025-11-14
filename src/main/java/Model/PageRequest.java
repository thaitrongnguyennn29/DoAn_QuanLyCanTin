package Model;

public class PageRequest {
    private int page;
    private int pageSize;
    private String sortField;
    private String sortOrder;
    private String keyword;
    public PageRequest(String keyword, String sortOrder, String sortField, int pageSize, int page) {
        this.keyword = keyword;
        this.sortOrder = sortOrder;
        this.sortField = sortField;
        this.pageSize = pageSize;
        this.page = page;
    }
    public PageRequest() {
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public String getSortField() {
        return sortField;
    }

    public void setSortField(String sortField) {
        this.sortField = sortField;
    }

    public String getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(String sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public int getOffset() {
        return (page - 1) * pageSize;
    }
}
