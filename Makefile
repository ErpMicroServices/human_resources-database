.PHONY = clean clean-files clean-docker docker

all : docker node_modules database_up.sql
	sudo docker commit new-human_resources-database erpmicroservices/human_resources-database:latest

docker :
	sudo docker build --tag new-human_resources-database --rm .
	sudo docker run -d --publish 5432:5432 --name new-human_resources-database new-human_resources-database
	sleep 10

node_modules : package.json
	npm install

sql/us-cities.sql : data_massagers/cities.csv
	node data_massagers/create_us_cities_sql.js

sql/us-zip-codes.sql : data_massagers/us-zip-codes.csv
	node data_massagers/create_us_zip_codes.js

database_up.sql : sql/*.sql database_change_log.yml
	liquibase --changeLogFile=./database_change_log.yml --url='jdbc:postgresql://localhost/human_resources-database' --username=human_resources-database --password=human_resources-database --outputFile=database_up.sql updateSql

clean : clean-docker clean-files

clean-files :
	-$(RM) -rf node_modules
	-$(RM) sql/us-cities.sql
	-$(RM) sql/us-zip-codes.sql
	-$(RM) database_up.sql
	-$(RM) databasechangelog.csv

clean-docker :
	if sudo docker ps | grep -q new-human_resources-database; then sudo docker stop new-human_resources-database; fi
	if sudo docker ps -a | grep -q new-human_resources-database; then sudo docker rm new-human_resources-database; fi
	if sudo docker images | grep -q new-human_resources-database; then sudo docker rmi new-human_resources-database; fi
	if sudo docker images | grep -q erpmicroservices/human_resources-database; then sudo docker rmi erpmicroservices/human_resources-database; fi
