package htl.it.brs.database.model;

public enum AccountRole {
    USER("User"),
    ADMIN("Admin"),
    BACKOFFICE("Backoffice"),
    NONE("None");
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
        if (requiredPerm == NONE)
            return true;

        if (this == ADMIN)
            return true;
        else if (this == BACKOFFICE && requiredPerm != ADMIN)
            return true;
        else return this == USER && requiredPerm == USER;
    }

}
