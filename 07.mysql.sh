common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh

my_sql_root_password=$1
service=mysql

function_MySQL


