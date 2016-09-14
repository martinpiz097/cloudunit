#!/usr/bin/env bash

# ###############################################################################
# ###############################################################################
# ###############################################################################

function compile_and_install_parent {
    mvn clean install -DskipTests
}

function run_webui {
    cd $CLOUDUNIT_HOME/cu-manager/src/main/webapp
    grunt serve
}

function run_tomcat {
    cd $CLOUDUNIT_HOME/cu-manager
    mvn clean compile tomcat7:run -DskipTests -Dspring.profiles.active=vagrant
}

function reset_vagrant {
    cd $CLOUDUNIT_HOME/cu-vagrant
    vagrant ssh -c "/home/vagrant/cloudunit/cu-platform/reset.sh -y"
}

function usage {
    echo "Usage: $0 (tomcat|reset)"
    echo "  tomcat : run tomcat without ide"
    echo "  reset  : delete all containers, volumes and database into vagrantbox"
	exit 1
}

function check_env {
    if [ "$USER" == "vagrant" ];
    then
        echo "Needed to be executed outside the vagrant box. Please exit"
        exit 1
    fi

    if [ $CLOUDUNIT_HOME -z ];
    then
        echo "You need to declare CLOUDUNIT_HOME as env variable"
        export CLOUDUNIT_HOME=`pwd`
        echo "CLOUDUNIT_HOME value is maybe : " + $CLOUDUNIT_HOME
        sleep 2
    fi
}

# ###############################################################################
# ###############################################################################
# ###############################################################################

check_env
compile_and_install_parent

while test $# -gt 0
do
    case "$1" in
        tomcat)
            run_tomcat
            ;;
        reset)
            reset_vagrant
            ;;
        *) echo "bad option $1"
    	   usage
            ;;
    esac
    shift
done

run_webui 2>&1 &
