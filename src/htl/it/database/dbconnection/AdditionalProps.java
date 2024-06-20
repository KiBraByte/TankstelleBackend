package htl.it.database.dbconnection;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * For each driver this enum contains all the possible properties, which may or may not be specified when connecting to a database.
 * For each property their datatype is also stored
 * */
public enum AdditionalProps {
    SQLSERVER("encrypt", Boolean.class, "databaseName", String.class),
    HSQLDB("hsqldb.lock_file", Boolean.class,"databaseName", String.class);

    private final LinkedHashMap<String,Class<?>> allowedProps;

    AdditionalProps(Object... props) {
        allowedProps = new LinkedHashMap<>();

        AtomicInteger counter = new AtomicInteger(0);
        List<AbstractMap.SimpleEntry<String, Class<?>>> keyVal = new ArrayList<>();
        Arrays.stream(props)
                .forEach(l -> {
                    int idx = counter.getAndIncrement();
                    if (idx % 2 == 0) keyVal.add(new AbstractMap.SimpleEntry<>((String) props[idx], Object.class));
                    else keyVal.get(idx / 2).setValue((Class<?>) props[idx]);
                });

        keyVal.forEach((entry) -> allowedProps.put(entry.getKey(), entry.getValue()));
    }

    @SuppressWarnings("unused")
    private Object[] getProps() {
        List<Object> props = new ArrayList<>();
        allowedProps.forEach((key, value) -> {
            props.add(key);
            props.add(value);
        });
        return props.toArray();
    }

    public LinkedHashMap<String, Class<?>> getAllowedProps() {
        return allowedProps;
    }
}
