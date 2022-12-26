
int main(){

	int *leds = (int*)0x20000000;
	*leds = 0x68;
	int i = 1;
	while(1);
}