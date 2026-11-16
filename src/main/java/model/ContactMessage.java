package model;

import java.util.Date;

public class ContactMessage {

    private int    messageId;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String subject;
    private String message;
    private Date   createdAt;
    private String status;

    public ContactMessage() {
    }

    public ContactMessage(int messageId, String fullName, String phoneNumber,
                          String email, String subject, String message,
                          Date createdAt, String status) {
        this.messageId   = messageId;
        this.fullName    = fullName;
        this.phoneNumber = phoneNumber;
        this.email       = email;
        this.subject     = subject;
        this.message     = message;
        this.createdAt   = createdAt;
        this.status      = status;
    }

    public int getMessageId()             { return messageId; }
    public void setMessageId(int v)       { this.messageId = v; }

    public String getFullName()           { return fullName; }
    public void setFullName(String v)     { this.fullName = v; }

    public String getPhoneNumber()        { return phoneNumber; }
    public void setPhoneNumber(String v)  { this.phoneNumber = v; }

    public String getEmail()              { return email; }
    public void setEmail(String v)        { this.email = v; }

    public String getSubject()            { return subject; }
    public void setSubject(String v)      { this.subject = v; }

    public String getMessage()            { return message; }
    public void setMessage(String v)      { this.message = v; }

    public Date getCreatedAt()            { return createdAt; }
    public void setCreatedAt(Date v)      { this.createdAt = v; }

    public String getStatus()             { return status; }
    public void setStatus(String v)       { this.status = v; }

    @Override
    public String toString() {
        return "ContactMessage{"
                + "messageId=" + messageId
                + ", fullName='" + fullName + '\''
                + ", phoneNumber='" + phoneNumber + '\''
                + ", email='" + email + '\''
                + ", subject='" + subject + '\''
                + ", status='" + status + '\''
                + ", createdAt=" + createdAt
                + '}';
    }
}
