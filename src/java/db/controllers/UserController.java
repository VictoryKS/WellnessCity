package db.controllers;

import db.dao.UserDAOImpl;
import db.table.User;
import java.util.List;
import javax.validation.Valid;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@Transactional
@RequestMapping(value = UserController.PATH)
public class UserController {
    public static final String PATH = "/users";
    
    @Autowired
    @Qualifier(value = "userDAO")
    public UserDAOImpl userDao = new UserDAOImpl();

    @Transactional
    @RequestMapping(value = "/getList", method = RequestMethod.POST)
    public @ResponseBody List<User> getList(@RequestParam(required = false) String username,
            @RequestParam(required = false) Boolean confirmed) {
        if (username != null && username.length() > 0) {
            return userDao.findByCriteria(Restrictions.like("username", username, MatchMode.ANYWHERE));
        }
        if (confirmed != null) {
            return userDao.findByCriteria(Restrictions.eq("confirmed", confirmed));
        }
        return userDao.findByCriteria();
    }
    
    @Transactional
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public @ResponseBody Long delete(@RequestParam Long id) {
        User user = userDao.findById(id);
        System.out.println(user.getName());
        user.setDeleted(Boolean.TRUE);
        userDao.update(user);
        return user.getId();
    }
    
    @Transactional
    @RequestMapping(value = "/confirm", method = RequestMethod.GET)
    public @ResponseBody Long confirm(@RequestParam Long id) {
        User user = userDao.findById(id);
        System.out.println(user.getName());
        user.setConfirmed(Boolean.TRUE);
        userDao.update(user);
        return user.getId();
    }
    
    @Transactional
    @RequestMapping(value = "/new", method = RequestMethod.GET)
    public String showForm(Model model) {
        model.addAttribute("user", new User());
        return "collaboration";
    }
    
    @Transactional
    @RequestMapping(value = "/new", method = RequestMethod.POST)
    public RedirectView submitForm(@Valid @ModelAttribute("user") User user, BindingResult result, Model model) {
       if (result.hasErrors()) {
           result.getFieldErrors().forEach((err) -> {
               System.out.println(err.getField() + " - " + err.getDefaultMessage());
           });
            return new RedirectView("/wellness/collaboration.htm?error=true");
        }
        userDao.persist(user);
        return new RedirectView("/wellness/map.htm");
    }
}
