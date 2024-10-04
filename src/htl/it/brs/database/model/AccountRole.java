package htl.it.brs.database.model;

public enum AccountRole {
    NONE("None"),
    USER("User"),
    BACKOFFICE("Backoffice"),
    ADMIN("Admin");
    private final String roleName;

    AccountRole(String roleName) {
        this.roleName = roleName;
    }

    public static AccountRole fromRoleName(String name) {
        for (AccountRole a : AccountRole.values())  {
            if (a.roleName.equalsIgnoreCase(name)) {
                return a;
            }
        }
        return AccountRole.NONE;
    }

    public boolean isAllowed(AccountRole requiredPerm) {
        return requiredPerm.ordinal() <= this.ordinal();
    }
}
