package Repository;

import Model.MonAn;
import Model.Quay;

public interface QuayRepository extends Repository<Quay>{
    Quay findByMaTK(int maTK);
}
