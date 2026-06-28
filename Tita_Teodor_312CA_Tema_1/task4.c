#include <stdio.h>

int main(void)
{
	unsigned int n;
	scanf("%u", &n);
	unsigned int searched_month;
	scanf("%u", &searched_month);

	unsigned int v[n];
	unsigned int month, day, id, amount;
	unsigned int k[5] = {0};

	for (unsigned int i = 0; i < n; i++) {
		scanf("%x", &v[i]);

		month = v[i] & 0xFF000000;
		month = month >> 24;
		day = v[i] & 0x00FF0000;
		day = day >> 16;
		id = v[i] & 0x0000FF00;
		id = id >> 8;
		amount = v[i] & 0x000000FF;

		if (month == searched_month) {
			if (id > 0 && id < 5) 
				k[id] = k[id] + amount;
		}
	}

	printf("1:%u\n", k[1]);
	printf("2:%u\n", k[2]);
	printf("3:%u\n", k[3]);
	printf("4:%u\n", k[4]);

	return 0;
}
