/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Mail;

import java.util.Date;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.activation.DataHandler;
import jakarta.activation.DataSource;
import java.util.List;

/**
 *
 * @author Asus
 */
public class Email {
    //  email:

    static final String from = "group4.sportstore@gmail.com";
    //  pass:
    static final String password = "szzu twhw yayc spad";

    public static void SendEmails(String to, String subject, String noidung) {

        //Properties: Khai báo các thuộc tính
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); //smtp host
        props.put("mail.smtp.port", "587"); //TLS 587 SSL 465
        props.put("mail.smtp.auth", "true");//auth
        props.put("mail.smtp.starttls.enable", "true");

        //create auhthenticator
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };
        //Phiên làm việc
        Session session = Session.getInstance(props, auth);
        //Gui email đến ai

        //Tạo tin nhắn  
        MimeMessage msg = new MimeMessage(session);
        try {
            //Kiểu nội dung
            msg.addHeader("Content-type", "text/HTML; charset=UTF-");
            //Người gửi
            msg.setFrom(from);
            //Người nhận
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            //Tiêu đề
            msg.setSubject(subject);
            //Quy định ngày gửi
            msg.setSentDate(new Date());
            //Quy định email nhận phản hồi
            //msg.setReplyTo(InternetAddress.parse(from,false))
            //Nội dung
            msg.setText(noidung, "UTF-8");
            //Gửi email
            Transport.send(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
