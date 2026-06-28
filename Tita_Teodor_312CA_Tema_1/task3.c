#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void get_items(void *suitcase, int *indices, int num_indices) 
{
	int temp = 0;
	if (!suitcase)
		return;

	if (!indices)
		return;

	int *header = (int *)suitcase;
	int n = header[0];
	int *offset = header + 1;
	int *type = header + n + 1;
	char *data = (char *)(header + 2 * n + 1);
	
	for (int i = 0; i < num_indices; i++) {
		if (type[indices[i]] == 1) {
			printf("%c", *(data + offset[indices[i]]));
		} else if (type[indices[i]] == 2) {
			temp = *(int *)(data + offset[indices[i]]);
			printf("%d", temp);
		} else if (type[indices[i]] == 3) {
			printf("\"%s\"", data + offset[indices[i]]);
		} else if (type[indices[i]] == 4) {
			temp = *(int *)(data + offset[indices[i]]);
			printf("0x%02X", temp);
		} else if (type[indices[i]] == 5) {
			temp = *(int *)(data + offset[indices[i]]);
			printf("0x%X", temp);
		}
		printf("\n");
	}
}

int main()
{
	int n, n_indices, var_type, val_int, lengh_string;
	char val_char;
	char val_string[256];
	scanf("%d", &n);
	int data_capacity = n * 8;
	void *suitcase_p = malloc(sizeof(int) + n * sizeof(int) * 2 + data_capacity);

	if (!suitcase_p)
		return 0;

	int k = 0;
	int *header = (int *)suitcase_p;
	header[0] = n;
	int *offset = header + 1;
	int *type = header + n + 1;
	char *data = (char *)(header + 2 * n + 1);
	int actual_offset = 0;
	
	for (int i = 0; i < n; i++) {
		scanf("%d", &var_type);

		if (var_type == 1) {
			getchar();
			scanf(" %c", &val_char);
			k = sizeof(char);
		} else if (var_type == 2) {
			scanf("%d", &val_int);
			k = sizeof(int);
		} else if (var_type == 3) {
			scanf("%d", &lengh_string);
			scanf("%s", val_string);

			if (lengh_string == 0) {
				val_string[0] = '\0';
			}

			k = lengh_string + 1;
		} else if (var_type == 4) {
			scanf("%i", &val_int);
			k = sizeof(int);
		} else if (var_type == 5) {
			scanf("%x", &val_int);
			k = sizeof(int);
		}

		if (actual_offset + k > data_capacity) {
			data_capacity = data_capacity + k + 100;
		
			void *new_suitcase = realloc(suitcase_p, sizeof(int) + n * sizeof(int) * 2 + data_capacity);

			if (!new_suitcase) {
				free(suitcase_p);
				return 0;
			}

			suitcase_p = new_suitcase;
			header = (int *)suitcase_p;
			offset = header + 1;
			type = header + n + 1;
			data = (char *)(header + 2 * n + 1);
		}

		type[i] = var_type;
		offset[i] = actual_offset;

		if (var_type == 1) {
			data[actual_offset] = val_char;
		} else if (var_type == 2) {
			*((int *)(data + actual_offset)) = val_int;
		} else if (var_type == 3) {
			memcpy(data + actual_offset, val_string, lengh_string + 1);
		} else if (var_type == 4) {
			*((int *)(data + actual_offset)) = val_int;
		} else if (var_type == 5) {
			*((int *)(data + actual_offset)) = val_int;
		}

		actual_offset = actual_offset + k;
	}

	scanf("%d", &n_indices);
	int *indices_p = malloc(n_indices * sizeof(int));

	if (!indices_p) {
		free(suitcase_p);
		return 0;
	}

	for (int i = 0; i < n_indices; i++) {
		scanf("%d", &indices_p[i]);
	}
	
	get_items(suitcase_p, indices_p, n_indices);

	free(suitcase_p);
	free(indices_p);
	return 0;
}
