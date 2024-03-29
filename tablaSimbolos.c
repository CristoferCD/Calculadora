#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "tablaSimbolos.h"
#include "calculadora.tab.h"
#include "funciones.h"

struct treeNode{
    itemNode* info;
    struct treeNode *left, *right;
};

typedef struct itemNode* node;
typedef struct treeNode* abb;

/////////////////////////////////////////////
itemNode* remove_last(abb *A) ;
void treeRemove(abb *A, char* key) ;
void destroy(abb* A) ;
itemNode* contains(abb* A, char* key) ;
void insert(abb *A, itemNode* element) ;
void printTree(abb* A) ;
////////////////////////////////////////////


// Variable used as root of the symbol table
abb *tableRoot;

void node_create(itemNode** newNode){
    *newNode = malloc(sizeof(struct itemNode));
}

char* node_getKey(node* element) {
    return (*element)->key;
}

void node_setKey(node* element, char* key) {
    (*element)->key = key;
}

int node_getId(node* element) {
    return (*element)->id;
}

void node_setId(node* element, int id) {
    (*element)->id = id;
}

double node_getNumValue(node *element) {
    return (*element)->numValue;
}

void node_setNumValue(node *element, double value) {
    (*element)->numValue = value;
}

double mySin(double value) {
    double toReturn = sin(value);
    printf("Calculated sin of %g: %g\n", value, toReturn);
    return toReturn;
}

void symbolTable_init() {
    tableRoot = malloc(sizeof(abb*));
    int i = 0;
    while(functionPointers[i] != NULL) {
        itemNode *aux = NULL;
        node_create(&aux);
        aux->key = functionKeys[i];
        aux->function = functionPointers[i];
        aux->id = FUNC;
        symbolTable_insert(aux);
        i++;
    }
    i = 0;
    while(constantValues[i] != 0) {
        itemNode *aux = NULL;
        node_create(&aux);
        aux->key = reservedConstants[i];
        aux->numValue = constantValues[i];
        aux->id = ID;
        symbolTable_insert(aux);
        i++;
    }
}


void symbolTable_free() {
    destroy(tableRoot);
}

void destroy(abb* A) {
    if (*A != NULL) {
        destroy(&(*A)->left);
        destroy(&(*A)->right);
        free(*A);
        *A = NULL;
    }
}

unsigned isEmpty(abb A) {
    return A == NULL;
}

void symbolTable_remove(char* key) {
    if (*tableRoot != NULL)
        treeRemove(tableRoot, key);
}

void treeRemove(abb *A, char* key) {
    abb aux;
    if (*A != NULL) {
        int keyComparison = strcmp(key, (*A)->info->key);
        if(keyComparison > 0)
            treeRemove(&(*A)->left, key);
        else if (keyComparison < 0)
            treeRemove(&(*A)->right, key);
        else if ((*A)->left == NULL && (*A)->right == NULL) {
            free((*A)->info->key);
            free(*A);
            *A = NULL;
        } else if ((*A)->left == NULL) {
            aux = *A;
            *A = (*A)->right;
            free(aux->info->key);
            free(aux);
        } else if ((*A)->right == NULL) {
            aux = *A;
            *A = (*A)->left;
            free(aux->info->key);
            free(aux);
        } else {
            (*A)->info = remove_last(&(*A)->right);
        }
    }
}

itemNode* remove_last(abb *A) {
    abb aux;
    itemNode* node;
    if ((*A)->left == NULL) {
        node = (*A)->info;
        aux = *A;
        *A = (*A)->right;
        free(aux);
        return node;
    } else {
        return remove_last(&(*A)->left);
    }
}

itemNode* contains(abb* A, char* key) {
    if(isEmpty(*A)) return NULL;
    else {
        int keyComparison = strcmp(key, (*A)->info->key);
        if (keyComparison == 0) return (*A)->info;
        else if (keyComparison > 0) return contains(&(*A)->right, key);
        else return contains(&(*A)->left, key);
    }
}

void symbolTable_insert(node element) {
    insert(tableRoot, element);
}

void insert(abb *A, itemNode* element) {
    if (isEmpty(*A)) {
        *A = malloc(sizeof(struct treeNode));
        (*A)->info = element;
        (*A)->left = NULL;
        (*A)->right = NULL;
    } else if (strcmp((*A)->info->key, element->key) > 0) {
        insert(&(*A)->left, element);
    } else {
        insert(&(*A)->right, element);
    }
}

void symbolTable_print() {
    printTree(tableRoot);
}

void printTree(abb* A) {
    if (!isEmpty(*A)) {
        printTree(&(*A)->left);
        printf("[TS] -- %s (%d)\n", (*A)->info->key, (*A)->info->id);
        printTree(&(*A)->right);
    }
}

itemNode* symbolTable_getComponent(char* key) {
    return contains(tableRoot, key);
}
