#include <stdio.h>
#include <stdint.h>

uint16_t encrypt_message(uint8_t msg, uint8_t key) 
{
	uint8_t xored_value = msg ^ key;
	uint8_t value;

	uint8_t r = 0;
	for (int i = 0; i < 8; i++) {
		r = r << 1;
		value = xored_value & 1;
		r = r | value;
		xored_value = xored_value >> 1;
	}

	uint16_t appended_value = 0;

	for (int i = 7; i >= 0; i--) {
		int bit_for_key = (key >> i) & 1;
		int bit_for_r = (r >> i) & 1;

		if (bit_for_key == bit_for_r) {
			if (bit_for_key) {
				appended_value = (appended_value << 1) | 1;
				appended_value = (appended_value << 1) | 1;
			} else {
				appended_value = (appended_value << 1);
				appended_value = (appended_value << 1) | 1;
			}
		} else {
			if (bit_for_key) {
				appended_value = (appended_value << 1);
				appended_value = (appended_value << 1);
			} else {
				appended_value = (appended_value << 1) | 1;
				appended_value = (appended_value << 1);
			}
		}
	}
	
	uint16_t final_value;
	uint16_t temp = appended_value & 0x00FF;
	temp = temp << 8;
	final_value = appended_value >> 8; 
	final_value = final_value | temp;

	return final_value;
}

int main()
{
	unsigned int message;
	scanf("%x", &message);
	unsigned int key;
	scanf("%x", &key);
	uint16_t final_value = encrypt_message((uint8_t)message, (uint8_t)key);
	printf("0x%04X\n", final_value);
	return 0;
}
