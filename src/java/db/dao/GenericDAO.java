package db.dao;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

public interface GenericDAO<T, ID extends Serializable> {

    T findById(ID id);

    List<T> findAll();

    T persist(T entity);

    void transience(T entity);
}