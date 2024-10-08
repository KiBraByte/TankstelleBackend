package htl.it.brs.database.model;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
public class AbrechnungsModel {
    int kundenNr;
    String kundenName;
    BigDecimal kundenPrice;

    public String toJSONString() {
        return String.format("{\"kundenNr\": %d, \"kundenName\": \"%s\", \"kundenPreis\": %s}", kundenNr, kundenName, kundenPrice);
    }
}
