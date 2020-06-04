package db.controllers;

import db.dao.PointDAOImpl;
import db.dao.UserDAOImpl;
import db.table.Point;
import db.table.User;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.validation.Valid;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@Transactional
@RequestMapping(value = PointController.PATH)
public class PointController {
    
    public static final String PATH = "/points";
    
    @Autowired
    @Qualifier(value = "pointDAO")
    public PointDAOImpl pointDao = new PointDAOImpl();

    @Autowired
    @Qualifier(value = "userDAO")
    public UserDAOImpl userDao = new UserDAOImpl();

    @Transactional
    @RequestMapping(value = "/getList", method = RequestMethod.POST)
    public @ResponseBody List<Point> getList(@RequestParam(required = false) String name,
            @RequestParam(required = false) String username, 
            @RequestParam(required = false) String address,
            @RequestParam(required = false) Long type) {
        ArrayList<Criterion> criterions = new ArrayList<>();
        
        if (username != null && username.length() > 0) {
            criterions.add(Restrictions.like("user.username", username, MatchMode.ANYWHERE));
        }
        if (name != null && name.length() > 0) {
            criterions.add(Restrictions.like("name", name, MatchMode.ANYWHERE));
        }
        if (address != null && address.length() > 0) {
            criterions.add(Restrictions.like("address", address, MatchMode.ANYWHERE));
        }
        if (type != null && type > 0) {
            criterions.add(Restrictions.eq("type", type));
        }
        
        return pointDao.findByCriteria(criterions.toArray(new Criterion[criterions.size()]));
    }
    
    @Transactional
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public @ResponseBody Long delete(@RequestParam Long id) {
        Point point = pointDao.findById(id);
        point.setDeleted(Boolean.TRUE);
        pointDao.update(point);
        return point.getId();
    }
    
    @Transactional
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String showForm(@RequestParam(required = false) Long id, Model model) {
        Point point = new Point();
        if (id != null && id > 0) {
            point = pointDao.findById(id);
            System.out.println(point.getName());
        }
        model.addAttribute("point", point);
        return "pointedit";
    }
    
    @Transactional
    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    public RedirectView submitForm(@Valid @ModelAttribute("point") Point point, BindingResult result, Model model) {
       if (result.hasErrors()) {
           result.getFieldErrors().forEach((err) -> {
               System.out.println(err.getField() + " - " + err.getDefaultMessage());
           });
        }
       
        String role = "";
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Collection<GrantedAuthority> authorities = (Collection<GrantedAuthority>) authentication.getAuthorities();
        for (GrantedAuthority authority : authorities) {
            role = authority.getAuthority();
        }
        
        if (point.getUser().getId() == null) {
            String username = authentication.getName();
            User user = userDao.findByCriteria(Restrictions.eq("username", username)).get(0);
            point.setUser(user);
        }
        pointDao.persist(point);
        
        model.addAttribute("point", point);
        RedirectView redirect = new RedirectView("/wellness/mypoints.htm");
        if (role.equals("ROLE_ADMIN")) {
            redirect = new RedirectView("/wellness/moderation.htm");
        }
        return redirect;
    }
}
