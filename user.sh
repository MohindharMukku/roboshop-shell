common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/common.sh

component=user
schema_setup=mongo
function_nodejs