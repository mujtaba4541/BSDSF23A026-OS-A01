#include "../include/myfilefunctions.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int wordCount(FILE* file, int* lines, int* words, int* chars) {
    if (file == NULL) return -1;
    
    rewind(file); // Reset file pointer to beginning
    
    int line_count = 0, word_count = 0, char_count = 0;
    int in_word = 0;
    char ch;
    
    while ((ch = fgetc(file)) != EOF) {
        char_count++;
        
        if (ch == '\n') {
            line_count++;
        }
        
        if (ch == ' ' || ch == '\n' || ch == '\t') {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            word_count++;
        }
    }
    
    // If file doesn't end with newline, count the last line
    if (char_count > 0) {
        line_count++;
    }
    
    *lines = line_count;
    *words = word_count;
    *chars = char_count;
    
    return 0;
}

int mygrep(FILE* fp, const char* search_str, char*** matches) {
    if (fp == NULL || search_str == NULL) return -1;
    
    rewind(fp);
    
    char line[256];
    int match_count = 0;
    int capacity = 10;
    char** match_list = malloc(capacity * sizeof(char*));
    
    while (fgets(line, sizeof(line), fp)) {
        if (strstr(line, search_str) != NULL) {
            // Resize if needed
            if (match_count >= capacity) {
                capacity *= 2;
                match_list = realloc(match_list, capacity * sizeof(char*));
            }
            
            // Allocate and copy the matching line
            match_list[match_count] = malloc(strlen(line) + 1);
            strcpy(match_list[match_count], line);
            match_count++;
        }
    }
    
    *matches = match_list;
    return match_count;
}
