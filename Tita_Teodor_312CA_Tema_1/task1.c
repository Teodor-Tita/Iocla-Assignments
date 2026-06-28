#include <stdio.h>
#include <stdlib.h>

void solve_itinerary(int rows, int cols, int matrix[rows][cols], int start_x, int start_y, unsigned char *instrs, int num_instrs) 
{
	int *verify_back = calloc(num_instrs, sizeof(int));

	if (!verify_back)
		return;

	int repeat = 1;

	for (int i = 0; i < num_instrs; i++) {
		unsigned char special_action = *(instrs + i) >> 4;
		unsigned char move_action = *(instrs + i) & 0x0F;
		unsigned char first_bit = special_action >> 3;
		unsigned char last_three = special_action & 0b00000111;

		if ((first_bit & 1) && (verify_back[i] == 0)) {
			verify_back[i] = 1;
			i = i - last_three -1;

			if (i < -1)
				i = -1;

			continue;
		} else {
			if (first_bit & 1) {
				repeat = 1;
			} else {
				if (last_three == 0)
					repeat = 1;
				else
					repeat = last_three;
			}

			while (repeat) {
				if (matrix[start_y][start_x] & move_action)
					break;

				if (start_x >= 0 && start_x < cols) {
					if (move_action & 0b00001000) {
						start_x--;

						if (start_x < 0) {
							start_x = 0;
							break;
						}
					}

					if (move_action & 0b00000010) {
						start_x++;

						if (start_x >= cols) {
							start_x = cols - 1;
							break;
						}
					}
				} else {
					break;
				}

				if (start_y >= 0 && start_y < rows) {
					if (move_action & 0b00000100) {
						start_y++;

						if (start_y >= rows) {
							start_y = rows - 1;
							break;
						}
						}

					if (move_action & 0b00000001) {
						start_y--;

						if (start_y < 0) {
							start_y = 0;
							break;
						}
					}
				} else {
					break;
				}
				repeat--;
			}
		}
	}
	printf("(%d,%d)\n", start_x, start_y);
	free(verify_back);
}

int main()
{
	int rows, cols, start_withx, start_withy, num_instrs;
	scanf("%d%d", &rows, &cols);

	if (rows >= 16 || cols >= 16)
		return 0;

	if (rows < 0 || cols < 0)
		return 0;

	int a[rows][cols];

	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++)
			scanf("%d", &a[i][j]);
	}

	scanf("%d%d", &start_withx, &start_withy);
	scanf("%d", &num_instrs);

	unsigned char *instructions_p = malloc(num_instrs * sizeof(unsigned char));

	if (!instructions_p)
		return 0;

	for (int i = 0; i < num_instrs; i++) {
		int k = 0;
		scanf("%d", &k);
		instructions_p[i] = (unsigned char)k;
	}

	solve_itinerary(rows, cols, a, start_withx, start_withy, instructions_p, num_instrs);

	free(instructions_p);
	return 0;
}
