// ColumnMajorTraversal.java

public class ColumnMajorTraversal {
    public static void main(String[] args) {
        // Initialize a 2D array
        int[][] array = new int[100][100000];

        // Fill the array with initial values
        for (int i = 0; i < 100; i++) {
            for (int j = 0; j < 100000; j++) {
                array[i][j] = i + j; // Example initialization
            }
        }

        long startTime = System.nanoTime(); // Start time measurement

        // Traverse the array in column-major order
        for (int j = 0; j < 100000; j++) {
            for (int i = 0; i < 100; i++) {
                array[i][j] *= 2; // Double each element
            }
        }

        long endTime = System.nanoTime(); // End time measurement
        long duration = endTime - startTime; // Calculate duration
        System.out.println("Column-major execution time: " + (duration / 1_000_000) + " ms"); // Print duration
    }
}
