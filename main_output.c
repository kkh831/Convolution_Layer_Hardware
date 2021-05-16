#include<stdio.h>
#include<stdlib.h>

int main(){



    FILE *fp=fopen("./0.bin","rb");

    fseek(fp,0,SEEK_END);
    int dat_size = ftell(fp)/sizeof(short);
    fseek(fp,0,SEEK_SET);

    unsigned short *dat;
    dat = (unsigned short *)malloc(dat_size*sizeof(short));
    fread(dat,sizeof(short),dat_size,fp);

    for(int idy = 0; idy<3; idy++){
        for(int idx = 0; idx<3; idx++){
            printf("%d ",dat[idy*3+idx]);
        }
        printf("\n");
    }


    return 0;


}
