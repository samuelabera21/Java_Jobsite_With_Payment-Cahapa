

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public HelloServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.getWriter().println("<h1>Hello from Servlet!</h1>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

//
//import java.io.IOException;
//import java.io.PrintWriter;//  PrintWriter 
//import javax.servlet.http.HttpServlet;ll// extends HttpServlet 
//import javax.servlet.http.HttpServletRequest;// HttpServletRequest
//import javax.servlet.http.HttpServletResponse;// HttpServletResponse 
//public class AddServlet extends HttpServlet {
////1.Method define server give service method and pass Rquest object  and respoonse  object
//    public void service(HttpServletRequest req,HttpServletResponse res) throws IOException
//    // Code to handle the request and send a response
//      // Get parameters from request frm user
//    {
//         int i = Integer.parseInt(req.getParameter("num1"));//get parameter request is string change to integer
//         int j = Integer.parseInt(req.getParameter("num2"));
//            
//            // Perform calculation
//            int k = i + j;
//            
//            // Send response to client
//            PrintWriter out = res.getWriter();
//            out.println("<h2>Result: " + k + "</h2>");
//    }
//}
