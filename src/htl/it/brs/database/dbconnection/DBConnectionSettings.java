package htl.it.brs.database.dbconnection;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Properties;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class DBConnectionSettings {
    private final HashMap<Conf, String> settings = new HashMap<>();

    /**
     * @param filePath The filepath of the config file
     * @return an instance of the Settings class, this instance can be used to get Settings specified in the Conf enum.
     * */
    public static DBConnectionSettings createSettings(String filePath) throws IOException {
        Properties props = new Properties();
        try (FileReader fr = new FileReader(filePath)) {
            props.load(fr);
        }
        DBConnectionSettings settings = new DBConnectionSettings();
        Arrays.stream(Conf.values()).forEach(c -> settings.settings.put(c,c.extractValue(props)));
        return settings;
    }

    public String getSetting(Conf conf) {
       return settings.get(conf);
    }

    public enum Conf {
        USERNAME("username"),
        PASSWORD("password"),
        DRIVER("driver"),
        LOCATION("location"),
        ADDITIONAL_PROPS(null);

        @Getter
        private final String confField;


        /**
         * Extracts the Property value for the enum variant
         * @param props all properties
         * @return the value of the Property
         * */
        private String extractValue(Properties props) {
            if (this == LOCATION && !props.containsKey(this.getConfField()))
                return String.format("%s:%s", props.getProperty("ip"), props.getProperty("port"));
            if (this == ADDITIONAL_PROPS) {
                StringBuffer add = new StringBuffer();

                String driver = props.getProperty(Conf.DRIVER.getConfField());
                AdditionalProps.valueOf(driver.toUpperCase()).getAllowedProps().keySet()
                        .forEach(prop -> {
                            String val = props.getProperty(prop);
                            if (val != null) add.append(String.format(" %s=%s;", prop, val));
                        });

                return add.toString();
            }

            return props.getProperty(this.getConfField());
        }

        Conf(String confField) {
            this.confField = confField;
        }
    }
}
