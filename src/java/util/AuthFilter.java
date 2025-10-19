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
        boolean loggedIn = session != null && session.getAttribute("adminUser") != null;

        if (!loggedIn && !path.endsWith("login.jsp") && !path.endsWith("login")) {
            resp.sendRedirect("login.jsp");
        } else {
            chain.doFilter(request, response);
        }
    }
}
