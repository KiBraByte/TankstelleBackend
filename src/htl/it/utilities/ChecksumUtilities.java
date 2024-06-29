package htl.it.utilities;

import java.util.Optional;

public class ChecksumUtilities {

    private static Optional<Integer> getLuhnSum(String numberString) {
        int sum = 0;
        for (int i = 0; i < numberString.length(); ++ i) {
            int curr_digit = ((int)numberString.charAt(numberString.length() - 1 - i)) - '0';

            if (curr_digit > 9 || curr_digit < 0) {
                return Optional.empty();
            }

            if (i % 2 == 0) {
                curr_digit *= 2;
            }

            sum += curr_digit > 9 ? curr_digit - 9 : curr_digit;
        }
        return Optional.of(sum);
    }

    //berechnet checksum
    public static Optional<Integer> useLuhnAlgo(String numberString) {
        Optional<Integer> sum = getLuhnSum(numberString);
        return sum.map((integer) -> (10 - (integer % 10)) % 10);
    }

    //verifiziert anhand checksum
    public static boolean verifyLuhnAlgo(String numberString) {
        final int lastDigit = numberString.charAt(numberString.length() - 1) - '0';
        return getLuhnSum(numberString.replace("-" + lastDigit, "")).filter((num) -> (num + lastDigit) % 10 == 0).isPresent();
    }
}
