// NEO GEO C ROMS COMBINER
// Usage: cromcombiner.exe -file1 -file2 ... -output
//
// ArcadeTV
// Created: 2023/11/12 09:46:28
// Last modified: 2023/11/13 09:46:18
// ------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    // Check if arguments count is even [exe + 2xC (+2xC)]
    // 3 arguments required (+1 for exe)
    if (argc < (3 + 1) || (argc % 2) != 0) {
        fprintf(stderr, "Invalid argument count.\n");
        return 1;
    }

    // Open input files
    int fileCount = argc - 2; // count input files
    FILE *files[fileCount];
    for (int i = 0; i < fileCount; i++) {
        files[i] = fopen(argv[i + 1], "rb");
        if (files[i] == NULL) {
            fprintf(stderr, "Error opening input file %s.\n", argv[i + 1]);
            return 2;
        }
    }

    // Open output files
    FILE *output = fopen(argv[argc - 1], "wb");
    if (output == NULL) {
        fprintf(stderr, "Error opening output file %s.\n", argv[argc - 1]);
        return 3;
    }

    // Interleaving
    char buffer[2];
    int activeFile = 0;
    while (1) {
        if (fread(buffer, 1, 2, files[activeFile]) < 2) {
            break; // EndOfFile or Error
        }
        fwrite(buffer, 1, 2, output);
        activeFile = (activeFile + 1) % fileCount;
    }

    // Close files
    for (int i = 0; i < fileCount; i++) {
        fclose(files[i]);
    }
    fclose(output);

    return 0;
}
