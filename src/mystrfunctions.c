#include "../include/mystrfunctions.h"

int mystrlen(const char* s) {
    int length = 0;
    while (s[length] != '\0') {
        length++;
    }
    return length;
}

int mystrcpy(char* dest, const char* src) {
    int i = 0;
    while (src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    dest[i] = '\0';
    return i;
}

int mystrncpy(char* dest, const char* src, int n) {
    int i;
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    for (; i < n; i++) {
        dest[i] = '\0';
    }
    return i;
}

int mystrcat(char* dest, const char* src) {
    int dest_len = mystrlen(dest);
    int i = 0;
    while (src[i] != '\0') {
        dest[dest_len + i] = src[i];
        i++;
    }
    dest[dest_len + i] = '\0';
    return dest_len + i;
}
