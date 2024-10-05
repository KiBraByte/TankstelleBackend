package htl.it.brs.database.model;

import lombok.Data;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class Tankkarte {
    private final BigDecimal kartenLimit;
    private final String pan;
    private final List<String> kartenProdukte = new ArrayList<>();


    public void addCardProdukt(String name) {
        this.kartenProdukte.add(name);
    }

    public String toJSONString() {
        return String.format("{\"pan\": \"%s\", \"kartenLimit\": %s, \"kartenProdukte\": [%s]}",
                this.pan,
                this.kartenLimit,
                this.kartenProdukte.stream()
                        .map(str -> String.format("\"%s\"", str))
                        .collect(Collectors.joining(","))
        );
    }
}
