##### Define function #########
function installpackage () {
    local packagename=${1}   #local variable within function
    apt-get install -y ${packagename}
    if [[ $? == 0 ]]
     then
       echo "${packagename} has been installed"
     else
       echo "${packagename} is not installed"
       exit 1
     fi
}

###### Define function #########
function maventarget () {
    local mavencmd=${1}
    mvn ${mavencmd}
    if [[ $? == 0 ]]
    then
        echo "${mavencmd} is success"
    else
        echo "${mavencmd} is fail"
        exit 1
    fi

}

if [[ $UID == 0 ]]
then
  echo "User is a root user"
else
  echo "user is not a root user" 
  exit 1
fi

sleep 2

#Update the system
yum update -y

if [[ $? == 0 ]] #if yum update command is executed then only further script will proceed.
then
   echo "apt-get update successfully"
else
   echo "apt-get update not successfull"
   exit 1
fi

sleep 2

#installpackage maven
#installpackage tomcat9
mvn test
mvn package


if [[ $? == 0 ]] #if mvn package command is executed then only further script will proceed
then
    echo " Maven test and Build has done"

    cp -rvf target/hello-world-0.0.1-SNAPSHOT.war /usr/local/tomcat9/webapps/dev_hellow.war   #this will copy built snapshot to apache weapps path

      if [[ $? == 0 ]] #if snapshot is copied then only further script will proceed
      then
	echo
        echo	
        echo "Hellow World is deployed successfully"
	echo
	echo
      else
	echo
        echo "Hellow world failed to deploye"
	echo
      fi
else
    echo
    echo "Maven test or build is failed"
    echo
fi    
