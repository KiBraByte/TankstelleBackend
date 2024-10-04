package htl.it.brs.database.model;

import lombok.Data;


@Data
public class LoginDaten {
    private final int sessionID;
    private final int sessionRole;


    public String toJSONString() {
        return String.format("{\"sessionID\": %d, \"sessionRole\": %d}", this.sessionID, this.sessionRole);
    }
}
