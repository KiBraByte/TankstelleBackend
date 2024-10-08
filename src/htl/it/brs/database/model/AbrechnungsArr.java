package htl.it.brs.database.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class AbrechnungsArr {
    private List<AbrechnungsModel> daten;

    public AbrechnungsArr() {
        daten = new ArrayList<>();
    }

    public void addAbrechnung(AbrechnungsModel model) {
        this.daten.add(model);
    }

    public String toJSONString() {
        return String.format("{\"kundenArray\": [%s]}",
                this.daten.stream()
                        .map(AbrechnungsModel::toJSONString)
                        .collect(Collectors.joining(",")));
    }
}
