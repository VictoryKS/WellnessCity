package db.dao;

import db.table.Point;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Component;

@Component("pointDAO")
public class PointDAOImpl extends GenericDAOImpl<Point, Long>{
    private Point init(Point one) 
    {
        one.setDeleted(Boolean.FALSE);
        return one;
    }
    
    @Override
    public Point persist(Point one) {
        return super.persist(init(one));
    }
    
    public Point update(Point one) {
        return super.persist(one);
    }
    
    @Override
    public List<Point> findByCriteria(Criterion... criterion) {
        Criteria crit = getSession().createCriteria(getPersistentClass(), "point")
                .createAlias("user", "user")
                .add(Restrictions.eq("point.deleted", Boolean.FALSE))
                .add(Restrictions.eq("user.deleted", Boolean.FALSE));

        for (Criterion c : criterion) {
            crit.add(c);
        }
        return crit.list();
   }
}
