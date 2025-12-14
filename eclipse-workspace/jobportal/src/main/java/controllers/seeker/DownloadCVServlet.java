package controllers.seeker;

import com.itextpdf.text.*;
import models.User;
import com.itextpdf.text.pdf.PdfWriter;
import dao.SeekerCVDAO;
import dao.SeekerCVDAOImpl;
import models.SeekerCV;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/seeker/downloadCV")
public class DownloadCVServlet extends HttpServlet {

    private SeekerCVDAO cvDAO = new SeekerCVDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
//            return;
//        }
//
//        int userId = (Integer) session.getAttribute("userId");
//        SeekerCV cv = cvDAO.getByUserId(userId);
    	
    	HttpSession session = request.getSession(false);

    	// Use seekerId instead of userId
    	Integer seekerId = (Integer) session.getAttribute("seekerId");
    	User seekerUser = (User) session.getAttribute("seekerUser");

    	if (session == null || seekerId == null || seekerUser == null) {
    	    response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=login_required");
    	    return;
    	}

    	int userId = seekerId; // Use seekerId
    	SeekerCV cv = cvDAO.getByUserId(userId);

        if (cv == null) {
            response.sendRedirect(request.getContextPath() + "/seeker/cvbuilder?error=no_cv");
            return;
        }

        // PDF RESPONSE
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=My_CV.pdf");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // -------- TITLE ----------
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD);
            Paragraph title = new Paragraph(cv.getHeadline(), titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // -------- ABOUT ----------
            Font sectionFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Font textFont = new Font(Font.FontFamily.HELVETICA, 12);

            document.add(new Paragraph("ABOUT ME", sectionFont));
            document.add(new Paragraph(cv.getAbout(), textFont));
            document.add(Chunk.NEWLINE);

            // -------- EDUCATION ----------
            document.add(new Paragraph("EDUCATION", sectionFont));
            addList(document, cv.getEducation());
            document.add(Chunk.NEWLINE);

            // -------- EXPERIENCE ----------
            document.add(new Paragraph("EXPERIENCE", sectionFont));
            addList(document, cv.getExperience());
            document.add(Chunk.NEWLINE);

            // -------- SKILLS ----------
            document.add(new Paragraph("SKILLS", sectionFont));
            addList(document, cv.getSkills());
            document.add(Chunk.NEWLINE);

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Converts JSON-like ["A","B"] to bullet list
    private void addList(Document doc, String jsonArray) throws Exception {
        if (jsonArray == null || jsonArray.equals("[]")) {
            doc.add(new Paragraph("No data available.\n"));
            return;
        }

        String trimmed = jsonArray.substring(1, jsonArray.length() - 1); // remove [ ]
        String[] items = trimmed.split(",");

        com.itextpdf.text.List pdfList = new com.itextpdf.text.List(com.itextpdf.text.List.UNORDERED);

        for (String raw : items) {
            String item = raw.trim();

            if (item.startsWith("\"")) item = item.substring(1);
            if (item.endsWith("\"")) item = item.substring(0, item.length() - 1);

            pdfList.add(new ListItem(item));
        }

        doc.add(pdfList);
    }
}
