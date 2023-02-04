#$(mysql -B -s --host="$host" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD"  -e 'select table_name from information_Schema.tables where table_schema="'""$MYSQL_DB""'";')
#pg_dump --host localhost --port 5432 --username root --format plain --verbose --file "/home/dev/mydatasql.sql" --table public.test mydata

echo $(pg_dump --host localhost --port 5432 --username root  --dbname mydata  -e 'select table_name from information_Schema.tables WHERE table_schema=public ');
# #!/usr/bin/env perl

# use strict;
# use warnings;

# my $database_name = 'mydata';

# my $query = <<"EOT";
# SELECT  n.nspname as table_schema,
#         c.relname as table_name
#     FROM pg_catalog.pg_class c
#         LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
#     WHERE c.relkind IN ('r','')
#         AND n.nspname NOT IN ('pg_catalog', 'information_schema')
#         AND n.nspname NOT LIKE '^pg_%'
#     ;
# EOT
# echo $query;
# $query =~ s/\n\s*/ /g;

# my @results = `echo  "$query" | psql -At $database_name`;
# foreach (@results) {
#     chomp;
#     my ($schema, $table) = split /\|/, $_;
#     next unless ($schema && $table);
#     my $cmd = "pg_dump -U root -Fp -t $schema.$table -f $schema.$table.dump $database_name";
#     system($cmd);
# }

# exit 1;