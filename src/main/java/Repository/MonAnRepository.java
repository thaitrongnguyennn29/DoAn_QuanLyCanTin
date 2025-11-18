package Repository;

import Model.MonAn;

import java.util.List;

public interface MonAnRepository extends Repository<MonAn> {
    List<MonAn> findByQuayId(int maQuay);
}
