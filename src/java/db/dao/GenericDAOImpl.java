package db.dao;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Criterion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

public abstract class GenericDAOImpl<T, ID extends Serializable>
        implements GenericDAO<T, ID> {

    private final Class<T> persistentClass;
    
    @Autowired
    @Qualifier(value = "sessionFactory")
    SessionFactory sessionFactory;
 
    public GenericDAOImpl() {
        this.persistentClass = (Class<T>) ((ParameterizedType) getClass()
                                .getGenericSuperclass()).getActualTypeArguments()[0];
    }

    protected Session getSession() {
        if (sessionFactory.getCurrentSession() == null)
            throw new IllegalStateException("Session has not been set on DAO before usage");
        return sessionFactory.getCurrentSession();
    }

    public Class<T> getPersistentClass() {
        return persistentClass;
    }

    @SuppressWarnings("unchecked")
    @Override
    public T findById(ID id) {
        return (T) getSession().load(getPersistentClass(), id);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<T> findAll() {
        return findByCriteria();
    }

    @SuppressWarnings("unchecked")
    @Override
    public T persist(T entity) {
        getSession().saveOrUpdate(entity);
        return entity;
    }

    @Override
    public void transience(T entity) {
        getSession().delete(entity);
    }

    public void flush() {
        getSession().flush();
    }

    public void clear() {
        getSession().clear();
    }

    @SuppressWarnings("unchecked")
    public List<T> findByCriteria(Criterion... criterion) {
        Criteria crit = getSession().createCriteria(getPersistentClass());
        for (Criterion c : criterion) {
            crit.add(c);
        }
        return crit.list();
   }
}