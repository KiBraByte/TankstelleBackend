package htl.it.brs.database.model;

import lombok.Data;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class KundenDaten {
    private final String firmenName;
    private final BigDecimal kundenLimit;
    private final BigDecimal fuelConsumedCostEur;
    private HashSet<String> produkte = new HashSet<>();

    private final List<Tankkarte> karten = new ArrayList<>();


    public void addProdukt(String name) {
        this.produkte.add(name);
    }

    public void addTankkarte(Tankkarte t) {
        this.karten.add(t);
    }

    public String toJSONString() {
        return String.format("{\"firmenName\": \"%s\", \"kundenLimit\": %s, \"getankt\": %s, \"produkte\": [%s], \"tankkarten\" : [%s]}",
                this.firmenName,
                this.kundenLimit,
                this.fuelConsumedCostEur,
                this.produkte.stream()
                        .map(str -> String.format("\"%s\"", str))
                        .collect(Collectors.joining(",")),
                this.karten.stream()
                        .map(Tankkarte::toJSONString)
                        .collect(Collectors.joining(","))
        );
    }
}
