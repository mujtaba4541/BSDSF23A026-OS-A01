#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../include/mystrfunctions.h"
#include "../include/myfilefunctions.h"

void test_string_functions() {
    printf("=== Testing String Functions ===\n");
    
    // Test mystrlen
    char str1[] = "Hello, World!";
    printf("1. mystrlen('%s') = %d\n", str1, mystrlen(str1));
    
    // Test mystrcpy
    char dest1[50];
    mystrcpy(dest1, "Copy this!");
    printf("2. mystrcpy result: '%s'\n", dest1);
    
    // Test mystrncpy
    char dest2[50] = "Initial text";
    mystrncpy(dest2, "Partial", 7);
    printf("3. mystrncpy result: '%s'\n", dest2);
    
    // Test mystrcat
    char dest3[50] = "Hello, ";
    mystrcat(dest3, "World!");
    printf("4. mystrcat result: '%s'\n", dest3);
    
    // Edge cases
    printf("5. mystrlen('') = %d\n", mystrlen(""));
    
    char empty_dest[10] = "";
    mystrcat(empty_dest, "Appended");
    printf("6. mystrcat to empty: '%s'\n", empty_dest);
}

void test_file_functions() {
    printf("\n=== Testing File Functions ===\n");
    
    // Create a comprehensive test file
    FILE* test_file = fopen("test.txt", "w");
    if (test_file) {
        fprintf(test_file, "This is line one.\n");
        fprintf(test_file, "This is line two with search term.\n");
        fprintf(test_file, "Line three has another search term here.\n");
        fprintf(test_file, "Final line without search word.\n");
        fclose(test_file);
        printf("Created test.txt\n");
    }
    
    // Test wordCount
    FILE* file = fopen("test.txt", "r");
    if (file) {
        int lines, words, chars;
        if (wordCount(file, &lines, &words, &chars) == 0) {
            printf("1. File stats: Lines=%d, Words=%d, Chars=%d\n", lines, words, chars);
        } else {
            printf("1. wordCount failed\n");
        }
        fclose(file);
    }
    
    // Test mygrep
    file = fopen("test.txt", "r");
    if (file) {
        char** matches;
        int match_count = mygrep(file, "search term", &matches);
        printf("2. Found %d lines containing 'search term':\n", match_count);
        for (int i = 0; i < match_count; i++) {
            printf("   %d: %s", i+1, matches[i]);
            free(matches[i]);
        }
        free(matches);
        fclose(file);
    }
    
    // Test with non-existent search term
    file = fopen("test.txt", "r");
    if (file) {
        char** matches;
        int match_count = mygrep(file, "nonexistent", &matches);
        printf("3. Lines containing 'nonexistent': %d\n", match_count);
        if (match_count > 0) {
            for (int i = 0; i < match_count; i++) {
                free(matches[i]);
            }
            free(matches);
        }
        fclose(file);
    }
}

int main() {
    printf("=== Static Library Version ===\n");
    test_string_functions();
    test_file_functions();
    
    printf("\n=== All tests completed ===\n");
    return 0;
}
