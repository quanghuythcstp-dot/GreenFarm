package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/branches")
public class BranchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("branches", buildBranches());
        request.getRequestDispatcher("/branches.jsp").forward(request, response);
    }

    // Branch data hardcoded — no database required for this feature.
    private List<Map<String, String>> buildBranches() {
        List<Map<String, String>> list = new ArrayList<>();

        list.add(branch(
            "GreenFarm Da Nang",
            "01",
            "29 An Thuong 4, My An, Ngu Hanh Son, Da Nang",
            "+84 359 151 256",
            "06:00 – 21:00 daily",
            "Nguyen Van An",
            "Fresh produce · Delivery · Click & Collect",
            "https://maps.google.com/maps?q=16.048722,108.246556&output=embed",
            "https://www.google.com/maps?q=16.048722,108.246556",
            "https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=600&q=80"
        ));

        list.add(branch(
            "GreenFarm Hai Chau",
            "02",
            "112 Tran Phu, Hai Chau 1, Hai Chau, Da Nang",
            "+84 359 151 257",
            "06:00 – 21:30 daily",
            "Tran Thi Bich",
            "Fresh produce · Organic · Catering",
            "https://maps.google.com/maps?q=Hai+Chau+Da+Nang+Vietnam&output=embed",
            "https://www.google.com/maps/search/Hai+Chau+Da+Nang+Vietnam",
            "https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80"
        ));

        list.add(branch(
            "GreenFarm Son Tra",
            "03",
            "45 Vo Nguyen Giap, Tho Quang, Son Tra, Da Nang",
            "+84 359 151 258",
            "06:30 – 21:00 daily",
            "Le Van Cuong",
            "Fresh produce · Delivery · Juice Bar",
            "https://maps.google.com/maps?q=Son+Tra+Da+Nang+Vietnam&output=embed",
            "https://www.google.com/maps/search/Son+Tra+Da+Nang+Vietnam",
            "https://images.unsplash.com/photo-1506484381205-f7945653044d?w=600&q=80"
        ));

        list.add(branch(
            "GreenFarm Hoa Xuan",
            "04",
            "78 Nguyen Phuoc Lan, Hoa Xuan, Cam Le, Da Nang",
            "+84 359 151 259",
            "07:00 – 21:00 daily",
            "Pham Thi Lan",
            "Fresh produce · Delivery · Click & Collect",
            "https://maps.google.com/maps?q=Hoa+Xuan+Cam+Le+Da+Nang+Vietnam&output=embed",
            "https://www.google.com/maps/search/Cam+Le+Da+Nang+Vietnam",
            "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=600&q=80"
        ));

        list.add(branch(
            "GreenFarm Lien Chieu",
            "05",
            "234 Ton Duc Thang, Hoa Khanh Nam, Lien Chieu, Da Nang",
            "+84 359 151 260",
            "06:00 – 20:30 daily",
            "Hoang Van Duc",
            "Fresh produce · Bulk orders · Catering",
            "https://maps.google.com/maps?q=Lien+Chieu+Da+Nang+Vietnam&output=embed",
            "https://www.google.com/maps/search/Lien+Chieu+Da+Nang+Vietnam",
            "https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=600&q=80"
        ));

        list.add(branch(
            "GreenFarm Ngu Hanh Son",
            "06",
            "15°58'13.8\"N 108°14'56.5\"E, Ngu Hanh Son, Da Nang",
            "+84 359 151 261",
            "06:00 – 21:00 daily",
            "Nguyen Thi Mai",
            "Fresh produce · Delivery · Click & Collect",
            "https://maps.google.com/maps?q=15.970500,108.248472&output=embed",
            "https://www.google.com/maps?q=15.970500,108.248472",
            "https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=600&q=80"
        ));

        return list;
    }

    private Map<String, String> branch(String name, String code, String address,
                                        String phone, String hours, String manager,
                                        String services, String mapEmbed,
                                        String mapLink, String image) {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("name",     name);
        m.put("code",     code);
        m.put("address",  address);
        m.put("phone",    phone);
        m.put("hours",    hours);
        m.put("manager",  manager);
        m.put("services", services);
        m.put("mapEmbed", mapEmbed);
        m.put("mapLink",  mapLink);
        m.put("image",    image);
        return m;
    }
}
