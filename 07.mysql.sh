common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh

my_sql_root_password=$1
service=mysql

if [ -z "my_sql_root_password"]; then
  echo "Input mysql root password is missing"
  exit 1
fi

function_MySQL


