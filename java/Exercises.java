import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.FileNotFoundException;

public class Exercises {

    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream()
                .filter(predicate)
                .map(String::toLowerCase)
                .findFirst();
    }

    public static Say say(String... words) {
        // Join words, and trim leading/trailing spaces
        String initialPhrase = String.join(" ", words).trim();
        return new Say(initialPhrase);
    }

    public static class Say {
        private final String accumulatedPhrase;

        public Say(String initialPhrase) {
            this.accumulatedPhrase = (initialPhrase == null) ? "" : initialPhrase.trim();
        }

        public Say and(String word) {
            // Handle empty or null strings gracefully
            if (word == null || word.trim().isEmpty()) {
                return this; // Return the current instance if the word is empty
            }

            // Create a new phrase; add a space before the new word if the accumulated
            // phrase is not empty
            String newPhrase = accumulatedPhrase.isEmpty() ? word : accumulatedPhrase + " " + word.trim();

            // Return a new instance with the updated phrase
            return new Say(newPhrase);
        }

        public String phrase() {
            return accumulatedPhrase;
        }
    }

    public static long meaningfulLineCount(String filename) throws FileNotFoundException, IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            return reader.lines()
                    .filter(line -> !line.trim().isEmpty() && line.trim().charAt(0) != '#')
                    .count();
        } catch (FileNotFoundException e) {
            throw new FileNotFoundException("No such file");
        }
    }

    // Write Quaternion record here

    // Write binary search tree here
}
