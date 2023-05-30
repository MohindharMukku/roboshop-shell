common_file=$(realpath "$0") #double quotes is used here to ensure filename as a single entity
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh

function_redis