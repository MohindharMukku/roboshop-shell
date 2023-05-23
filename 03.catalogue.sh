common_file=$(realpath "$0") #double quotes is used here to ensure filename as a single entity
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh



component=catalogue
schema_setup=mongo
function_nodejs

#update the catalogue server IP address in frontend file - /etc/nginx/default.d/01.roboshop.conf