package utils;

public class Validation {

    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isEmail(String email) {
        if (isEmpty(email)) return false;
        return email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    public static boolean isPhone(String phone) {
        if (isEmpty(phone)) return false;
        // Vietnamese phone numbers: 10 digits, starting with 0
        return phone.matches("^0\\d{9}$");
    }

    public static boolean isNumber(String value) {
        if (isEmpty(value)) return false;
        return value.matches("^\\d+(\\.\\d+)?$");
    }
}
