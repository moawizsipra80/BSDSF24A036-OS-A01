#include <stdio.h>
#include <stdlib.h>
#include "../include/mystfunctions.h"
#include "../include/myfilefunctions.h"

int main() {
    printf("--- Testing String Functions ---\n");

    const char* str1 = "Hello";
    printf("mystrlen(\"%s\") = %d\n", str1, mystrlen(str1));

    char dest1[50];
    mystrcpy(dest1, "World");
    printf("mystrcpy -> \"%s\"\n", dest1);

    char dest2[50];
    mystrncpy(dest2, "Programming", 5);
    dest2[5] = '\0';
    printf("mystrncpy (first 5 chars) -> \"%s\"\n", dest2);

    char dest3[50] = "Hello ";
    mystrcat(dest3, "World");
    printf("mystrcat -> \"%s\"\n", dest3);

    printf("\n--- Testing File Functions ---\n");

    FILE* fp = fopen("test.txt", "r");
    if (fp == NULL) {
        printf("test.txt file nahi mili. Ek test.txt banao.\n");
    } else {
        int lines = 0, words = 0, chars = 0;
        if (wordCount(fp, &lines, &words, &chars) == 0) {
            printf("Lines: %d, Words: %d, Chars: %d\n", lines, words, chars);
        }
        fclose(fp);
    }

    fp = fopen("test.txt", "r");
    if (fp != NULL) {
        char* matches[100];
        int count = mygrep(fp, "hello", matches);
        printf("mygrep(\"hello\") found %d matches\n", count);
        for (int i = 0; i < count; i++) {
            printf("  Match %d: %s", i + 1, matches[i]);
            free(matches[i]);
        }
        fclose(fp);
    }

    return 0;
}