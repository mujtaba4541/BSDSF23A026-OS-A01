#include <stdio.h>
#include <stdlib.h>
#include "../include/mystrfunctions.h"
#include "../include/myfilefunctions.h"

void test_string_functions() {
    printf("=== Testing String Functions ===\n");
    
    // Test mystrlen
    char str1[] = "Hello, World!";
    printf("mystrlen('%s') = %d\n", str1, mystrlen(str1));
    
    // Test mystrcpy
    char dest1[50];
    mystrcpy(dest1, "Copy this!");
    printf("mystrcpy result: '%s'\n", dest1);
    
    // Test mystrncpy
    char dest2[50] = "Initial text";
    mystrncpy(dest2, "Partial", 7);
    printf("mystrncpy result: '%s'\n", dest2);
    
    // Test mystrcat
    char dest3[50] = "Hello, ";
    mystrcat(dest3, "World!");
    printf("mystrcat result: '%s'\n", dest3);
}

void test_file_functions() {
    printf("\n=== Testing File Functions ===\n");
    
    // Create a test file
    FILE* test_file = fopen("test.txt", "w");
    if (test_file) {
        fprintf(test_file, "This is line one.\nThis is line two with search term.\nLine three.\n");
        fclose(test_file);
    }
    
    // Test wordCount
    FILE* file = fopen("test.txt", "r");
    if (file) {
        int lines, words, chars;
        if (wordCount(file, &lines, &words, &chars) == 0) {
            printf("File stats: Lines=%d, Words=%d, Chars=%d\n", lines, words, chars);
        }
        fclose(file);
    }
    
    // Test mygrep
    file = fopen("test.txt", "r");
    if (file) {
        char** matches;
        int match_count = mygrep(file, "search term", &matches);
        printf("Found %d lines containing 'search term':\n", match_count);
        for (int i = 0; i < match_count; i++) {
            printf("  %d: %s", i+1, matches[i]);
            free(matches[i]);
        }
        free(matches);
        fclose(file);
    }
}

int main() {
    test_string_functions();
    test_file_functions();
    return 0;
}
