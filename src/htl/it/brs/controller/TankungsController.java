package htl.it.brs.controller;

import htl.it.brs.database.callable.SPTankungAnlegen;
import htl.it.brs.database.dbconnection.DBConnection;
import htl.it.brs.database.model.AccountRole;
import htl.it.brs.utilities.ChecksumUtilities;
import http.server.implementation.common.status.HTTPStatus;
import http.server.implementation.request.HTTPMethod;
import http.server.implementation.request.HTTPRequest;
import http.server.implementation.response.ResponseBuilder;
import lombok.Getter;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashMap;

public class TankungsController extends Controller {

    private static final int PAN_LENGTH = 18;
    public TankungsController(DBConnection dbConnection) {
        super(dbConnection);
    }

    @Override
    public ResponseBuilder controller(HTTPRequest req, ResponseBuilder res, HashMap<String, String> param) {
        if (super.requiresHigherPermissions(req)) {
            return super.buildErrorResponse(res, HTTPStatus.REDIRECT_302_TEMP, "Not authenticated!");
        }

        String[] requiredFields = new String[] {"pan"/*, "produkt"*/, "tsnr", "menge", "preisproeinheit"};
        if (!req.getBody().keySet().containsAll(Arrays.asList(requiredFields))) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Fields missing!");
        }

        String pan = req.getBody().get("pan");
        System.out.println(pan.length());
        if (pan.length() != PAN_LENGTH || !ChecksumUtilities.verifyLuhnAlgo(pan)) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Invalid PAN!");
        }

        try {
            int tsnr = Integer.parseInt(req.getBody().get("tsnr"));
            BigDecimal menge = new BigDecimal(req.getBody().get("menge"));
            BigDecimal preisProEinheit = new BigDecimal(req.getBody().get("preisproeinheit"));

            int result = new SPTankungAnlegen(dbConnection, pan, tsnr, menge, preisProEinheit).call();

            if (result > TankungStatus.values().length - 1) {
                return super.buildErrorResponse(res, HTTPStatus.SERVER_ERR_500_GENERAL, "Update TankungStatus!");
            } else if (result > 0) {
                System.out.println(result);
                return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, TankungStatus.values()[result].getMsg());
            }

            return res.setStatus(HTTPStatus.SUCCESS_201_CREATED).send(String.format("{ \"msg\": \"%s\" }", "Success!"));
        } catch (Exception e) {
            return super.buildErrorResponse(res, HTTPStatus.CLIENT_ERR_400_BAD_REQUEST, "Error!");
        }
    }

    @Override
    public String getRoute() {
        return "/api/tankunganlegen";
    }

    @Override
    public HTTPMethod getHTTPMethod() {
        return HTTPMethod.POST;
    }

    @Getter
    private enum TankungStatus {
        SUCCESS("SUCCESS"),
        CARD_EXPIRED("Card expired!"),
        CARD_DISABLED("Card is disabled!"),
        CARD_LIMIT_REACHED("Transaction exceeds card limit!"),
        CARD_INVALID_PRODUCT("Product is not enabled for this card!"),
        CUSTOMER_DISABLED("Customer is disabled!"),
        CUSTOMER_LIMIT_REACHED("Transactions exceeds customer limit!");

        private final String msg;

        TankungStatus(String msg) {
            this.msg = msg;
        }

    }

    @Override
    public AccountRole getRequiredRole() {
        return AccountRole.BACKOFFICE;
    }
}
