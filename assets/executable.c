
darwin_luacembed
cincludes
int main(int argc,char *argv[]){
LuaCEmbed *main_obj = newLuaCEmbedEvaluation();
    LuaCEmbed_load_native_libs(main_obj);

    LuaCEmbedTable *args_table =LuaCembed_new_global_table(main_obj,"args");
        for(int i =0; i <argc;i++){
            LuaCEmbedTable_append_string(args_table,argv[i]);
        }

    darwin_cglobals
    ccalls
    LuaCEmbed_evaluate(main_obj, "%s",(const char[])darwin_execcode);
    if(LuaCEmbed_has_errors(main_obj)){
        printf("%s\n",LuaCEmbed_get_error_message(main_obj));
    }
    LuaCEmbed_free(main_obj);
}
