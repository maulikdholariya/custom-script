
helpFunction()
{
   echo ""
   echo " ⚠️  Usage: $0 -u user -p password -d database -h host -t table? ⚠️"
   exit 1 # Exit script after printing help
}

while getopts "u:p:d:h:t:" opt
do
   case "$opt" in
      u ) user="$OPTARG" ;;
      p ) password="$OPTARG" ;;
      d ) database="$OPTARG" ;;
      h ) host="$OPTARG" ;;
      t ) table="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$user" ] || [ -z "$password" ] || [ -z "$database" ] || [ -z "$host" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Change the database name 
MYSQL_DB=$database
MYSQL_USER=$user
MYSQL_PASSWORD=$password
#Provide the backup directory path in which you would like to create new direcoty and backup tables from a Database. In my case I have directory /tmp
CUR_DIR=$(pwd)
BACKUP_DIR=$CUR_DIR/$MYSQL_DB"_"$(date +%Y-%m-%d-%H-%M-%S);
echo "📂" $BACKUP_DIR

# Print helpFunction in case parameters are empty
if [ -z "$table" ]
then
   echo "Usage: $0 -u user -p password -d database -h host -t table?";
   # helpFunction
else
tb=$table;
BACKUP_DIR=$CUR_DIR/$MYSQL_DB"_"$tb"_"$(date +%Y-%m-%d-%H-%M-%S);
#Check and create new directory if not exists
$MYSQL_DB -d "$BACKUP_DIR" || mkdir -p "$BACKUP_DIR"

  mysqldump  --host="$host"  --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" "$MYSQL_DB" "$tb" --routines --skip-lock-tables> "$BACKUP_DIR/$tb.sql"
echo " ✅ mysqldump --host="$host" --user="$MYSQL_USER "--password="$MYSQL_PASSWORD $MYSQL_DB  $tb" --routines --skip-lock-tables> "$BACKUP_DIR/$tb.sql

chmod -R 777 "$BACKUP_DIR"
echo "🚀🚀 🥳 Downloaded path 📂 :" $BACKUP_DIR
exit 1;
fi
#Check and create new directory if not exists
$MYSQL_DB -d "$BACKUP_DIR" || mkdir -p "$BACKUP_DIR"
# Get the Table List for the database you have provide above
for tb in $(mysql -B -s --host="$host" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD"  -e 'select table_name from information_Schema.tables where table_schema="'""$MYSQL_DB""'";')
do

echo "⚙️ Taking backup of Table : "$tb
  # backup each table in a separate file
  mysqldump --host="$host" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" "$MYSQL_DB" "$tb" --routines --skip-lock-tables> "$BACKUP_DIR/$tb.sql"
echo " ✅  mysqldump --host="$host" --user="$MYSQL_USER "--password="$MYSQL_PASSWORD $MYSQL_DB $tb" --routines --skip-lock-tables> "$BACKUP_DIR/$tb.sql
done
chmod -R 777 "$BACKUP_DIR"
echo "🚀🚀 🥳 Downloaded path 📂 :" $BACKUP_DIR
#sudo mysqldump --user="root" --password="root" "test" -h "localhost" "emails" --skip-lock-tables> /home/dev/test_watched_3d_2022-12-17-16-46-33/watched_3d.sql

