public class TraversalBatchRunner {
    public static void main(String[] args) throws Exception {
        int iterations = 10; // Anzahl der Durchläufe pro Klasse
        long totalRowMajorTime = 0;
        long totalColumnMajorTime = 0;

        System.out.println("Starting batch execution of RowMajorTraversal and ColumnMajorTraversal...");

        // Mehrfache Ausführung von RowMajorTraversal
        for (int i = 0; i < iterations; i++) {
            Process rowMajorProcess = runExternalJavaClass("RowMajorTraversal");
            long rowMajorTime = readExecutionTime(rowMajorProcess);
            totalRowMajorTime += rowMajorTime;
        }

        // Mehrfache Ausführung von ColumnMajorTraversal
        for (int i = 0; i < iterations; i++) {
            Process columnMajorProcess = runExternalJavaClass("ColumnMajorTraversal");
            long columnMajorTime = readExecutionTime(columnMajorProcess);
            totalColumnMajorTime += columnMajorTime;
        }

        // Durchschnittszeiten berechnen
        long avgRowMajorTime = totalRowMajorTime / iterations;
        long avgColumnMajorTime = totalColumnMajorTime / iterations;

        // Ergebnisse ausgeben
        System.out.println("\nResults:");
        System.out.println("Average Row-Major Execution Time: " + avgRowMajorTime + " ms");
        System.out.println("Average Column-Major Execution Time: " + avgColumnMajorTime + " ms");
    }

    /**
     * Führt eine externe Java-Klasse aus.
     */
    private static Process runExternalJavaClass(String className) throws Exception {
        String command = "java " + className;
        Process process = Runtime.getRuntime().exec(command);
        process.waitFor(); // Warten, bis der Prozess abgeschlossen ist
        return process;
    }

    /**
     * Liest die Ausführungszeit aus der Standardausgabe des Prozesses.
     */
    private static long readExecutionTime(Process process) throws Exception {
        try (java.io.BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(process.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("execution time:")) {
                    // Extrahiere die Ausführungszeit in Millisekunden
                    return Long.parseLong(line.replaceAll("[^0-9]", ""));
                }
            }
        }
        throw new RuntimeException("Execution time not found in process output");
    }
}