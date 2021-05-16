#include<stdio.h>
#include<stdlib.h>

int main(){



    FILE *fp=fopen("./0.bin","rb");

    fseek(fp,0,SEEK_END);
    int dat_size = ftell(fp)/sizeof(char);
    fseek(fp,0,SEEK_SET);

    unsigned char *dat;
    dat = (unsigned char *)malloc(dat_size*sizeof(char));
    fread(dat,sizeof(char),dat_size,fp);

    for(int idy = 0; idy<5; idy++){
        for(int idx = 0; idx<5; idx++){
            printf("%d ",dat[idy*5+idx]);
        }
        printf("\n");
    }


    return 0;


}
