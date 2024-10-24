
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include <sys/file.h>
#include <sys/time.h>


#ifdef __linux__
#include <sys/wait.h>
  #include <dirent.h>
  #include <unistd.h>
#elif _WIN32
  #include <windows.h>
  #include <tchar.h>
  #include <wchar.h>
  #include <locale.h>
  #include <direct.h>
#endif


unsigned char *load_any_content(const char * path,long *size,bool *is_binary){

    *is_binary = false;
    *size = 0;


    FILE  *file = fopen(path,"rb");

    if(file ==NULL){
        return NULL;
    }


    if(fseek(file,0,SEEK_END) == -1){
        fclose(file);
        return NULL;
    }


    *size = ftell(file);

    if(*size == -1){
        fclose(file);
        return NULL;
    }

    if(*size == 0){
        fclose(file);
        return NULL;
    }


    if(fseek(file,0,SEEK_SET) == -1){
        fclose(file);
        return NULL;
    }

    unsigned char *content = (unsigned char*)malloc(*size +1);
    int bytes_read = fread(content,1,*size,file);
    if(bytes_read <=0 ){
        free(content);
        fclose(file);
        return NULL;
    }


    *is_binary = false;
    for(int i = 0;i < *size;i++){
        if(content[i] == 0){
            *is_binary = true;
            break;
        }
    }
    content[*size] = '\0';

    fclose(file);
    return content;
}

bool write_any_content(const char *path,unsigned  char *content,long size){
    //Iterate through the path and create directories if they don't exist
    FILE *file = fopen(path,"wb");
    if(file == NULL){

        return false;
    }

    fwrite(content, sizeof(char),size, file);

    fclose(file);
    return true;
}

void concat_str(
     char *dest,
    const  char *value,
    int value_size,
    int *acumulated_size
){
    memcpy((dest+ *acumulated_size),value,value_size);
    *acumulated_size+=value_size-1;
}

int main(int argc,char *argv[]){

    if(argc < 2){
        printf("argv[2] not provided \n");
        return 1;
    }

    bool is_binary;
    long size;
    unsigned char *file = load_any_content(argv[1],&size,&is_binary);
    if(file == NULL){
        printf("file not provided\n");
        return 1;
    }

    if(is_binary){
        free(file);
        printf("its not a valid file\n");
        return 1;
    }
    const int BUFFER_SIZE = 6;
    const char start[]  = "unsigned char lua_code[] = {";
    int required_final_size = (size * BUFFER_SIZE) + sizeof(start) + 2;
     char *final = calloc(required_final_size, sizeof(unsigned char));

    int actual_size = 0;
    concat_str(final,start,sizeof(start),&actual_size);

    for(int i = 0; i< size; i++){
        char buffer[BUFFER_SIZE];
        int buffer_size = sprintf(buffer,"%d,", file[i]);
        concat_str(final,buffer,buffer_size,&actual_size);
    }

    const char end_acumulator[] = "0};";
    concat_str(final,end_acumulator,sizeof(end_acumulator),&actual_size);

    write_any_content("teste.c",(unsigned char*)final,strlen(final));
    free(final);
    free(file);
}
