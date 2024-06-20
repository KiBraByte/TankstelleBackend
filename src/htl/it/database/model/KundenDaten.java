package htl.it.database.model;

import lombok.Data;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class KundenDaten {
    private final String firmenName;
    private final BigDecimal kundenLimit;
    private final BigDecimal fuelConsumedCostEur;
    private List<String> produkte = new ArrayList<>();


    public void addProdukt(String name) {
        this.produkte.add(name);
    }

    public String toJSONString() {
        return String.format("{\"firmenName\": \"%s\", \"kundenLimit\": %s, \"getankt\": %s, \"produkte\": [%s]}",
                this.firmenName,
                this.kundenLimit,
                this.fuelConsumedCostEur,
                this.produkte.stream().map(str -> String.format("\"%s\"", str)).collect(Collectors.joining(","))
        );
    }
}
