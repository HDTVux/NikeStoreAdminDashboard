package util;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();

        // Không filter trang login, LoginServlet và tài nguyên tĩnh
        boolean isLoginPage = path.endsWith("login.jsp") || path.endsWith("LoginServlet");
        boolean isStatic = path.contains("/assets/") || path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".jpg");

        // Đã đăng nhập và đúng quyền admin
        boolean loggedIn = false;
        if (session != null && session.getAttribute("authUser") != null) {
            // kiểm tra luôn role
            model.User u = (model.User) session.getAttribute("authUser");
            if (u.getRole() != null && u.getRole().equalsIgnoreCase("admin")) {
                loggedIn = true;
            }
        }

        if (!loggedIn && !isLoginPage && !isStatic) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            chain.doFilter(request, response);
        }
    }
}
