package db.dao;

import db.table.User;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Component;


@Component("userDAO")
public class UserDAOImpl extends GenericDAOImpl<User, Long> {
    private User init(User one) 
    {
        one.setDeleted(Boolean.FALSE);
        one.setConfirmed(Boolean.FALSE);
        one.setRole(User.ROLE_USER);
        one.setAuthority(User.AUTHORITY_USER);
        return one;
    }

    @Override
    public User persist(User one) {
        return super.persist(init(one));
    }
    
    public User update(User one) {
        return super.persist(one);
    }
    
    @Override
    public List<User> findByCriteria(Criterion... criterion) {
        Criteria crit = getSession().createCriteria(getPersistentClass())
                .add(Restrictions.eq("deleted", Boolean.FALSE));

        for (Criterion c : criterion) {
            crit.add(c);
        }
        return crit.list();
   }
}
