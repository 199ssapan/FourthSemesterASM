#include <stdio.h>
unsigned int crc16(unsigned char* packet, int nBytes)
{
    int crc = 0;
    for (int byte = 0; byte < nBytes; byte++)
    {
        crc = crc ^ ((unsigned int)packet[byte] << 8);
        for (unsigned char bit = 0; bit < 8; bit++)
        {
            if (crc & 0x8000)
            {
                crc = (crc << 1) ^ 0x1021;
            }
            else
            {
                crc = crc << 1;
            }
        }
    }
    return crc & 0xffff;
}
int main()
{
    printf("%x", crc16("String", 6));
    return 0;
}
