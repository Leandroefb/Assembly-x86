#include <stdio.h>

void symm2(int m, int n, float alpha, float beta, float A[m][m], float B[m][n], float C[m][n]) {
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            float temp2 = 0;
            for (int k = 0; k < i; k++) {
                C[k][j] += alpha * B[i][j] * A[i][k];
                temp2 += B[k][j] * A[i][k];
            }
            C[i][j] = beta * C[i][j] + alpha * B[i][j] * A[i][i] + alpha * temp2;
        }
    }
}

int symm (int m, int n, float alpha, float beta, float A[m][m], float B[m][n], float C[m][n]);

int main() {
    int m, n;

    // Get matrix sizes from the user
    printf("Enter the number of rows (m): ");
    scanf("%d", &m);
    printf("Enter the number of columns (n): ");
    scanf("%d", &n);

    float alpha, beta;

    // Get alpha and beta values from the user
    printf("Enter the value of alpha: ");
    scanf("%f", &alpha);
    printf("Enter the value of beta: ");
    scanf("%f", &beta);

    // Declare matrices A, B, and C based on user input
    float A[m][m], B[m][n], C[m][n];

    // Get values for matrix A from the user
    printf("Enter values for matrix A (%dx%d):\n", m, m);
    for (int i = 0; i < m; i++)
        for (int j = 0; j < m; j++)
            scanf("%f", &A[i][j]);

    // Get values for matrix B from the user
    printf("Enter values for matrix B (%dx%d):\n", m, n);
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            scanf("%f", &B[i][j]);

    // Initialize matrix C to zero
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            C[i][j] = 0;

    // Call the symm function with user-provided values
    symm2(m, n, alpha, beta, A, B, C);

    // Print the result
    printf("Resulting matrix C1 (%dx%d):\n", m, n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f ", C[i][j]);
        }
        printf("\n");
    }

    // Initialize matrix C to zero
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            C[i][j] = 0;

    __asm__  (
        "movl %0, %%eax\n"
        "cltq\n"
        "pushl %%rax\n"
        "push %1\n"
        "push %2\n"
        "push %3\n"
        "pushq %4\n"
        "pushq %5\n"
        "pushq %6\n"
        "call symm"
        :
        : "r" (m), "r" (n), "r" (alpha), "r" (beta), "r" (A), "r" (B), "r" (C)
        : "%rax"
    );


    printf("Resulting matrix C2 (%dx%d):\n", m, n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f ", C[i][j]);
        }
        printf("\n");
    }

    return 0;
}