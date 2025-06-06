#!/bin/bash

#by Kasama, https://bbs.archlinux.org/viewtopic.php?id=91452
#--VARIABLES--
WDIR="$HOME/.pacleanup"
EXPLINST="$WDIR/explicitly-installed"
WRKLIST="$WDIR/working-list"
DEPLIST="$WDIR/dep-list"
KEEPS="$WDIR/keep-pkgs"
REMS="$WDIR/rm-pkgs"
SAFEREMS="$WDIR/rm-safe"
TMPREMS="$SAFEREMS.tmp"
TMPEXPL="$EXPLINST.tmp"
TMPDEPLIST="$DEPLIST.tmp"
#/VARIABLES

set -u

#--FUNCTIONS--
#SYSTEM CHECKS
checks () {
echo "==> Running checks..."

#Check user
guy=`whoami`

if [ "$guy" = "root" ]
then
  echo
  echo "==> Please run as normal user with sudo privileges"
  exit 1
fi

#Check working directory
if [ -d $WDIR ]
then
  echo
  echo "==> $WDIR exists"
else
  mkdir -p $WDIR
  echo
  echo "==> $WDIR created"
fi

#Check working files
fileCheck $EXPLINST
fileCheck $REMS
fileCheck $SAFEREMS
fileCheck $WRKLIST
fileCheck $DEPLIST

#Get list of explicitly installed packages
getExplInst

#Process existing list of packages to keep or ceate new file
if [ -f $KEEPS ]
then
  keepCheck=`cat $KEEPS`
  if [ -n "$keepCheck" ]
  then
    echo
    echo "==> Old $KEEPS detected!"
    echo "==> You can use this list to automatically keep these packages"
    echo "==> Do you want to keep your old list? [y/n]"
    read ans
    case $ans in
      y)
    touch $KEEPS
    cp $EXPLINST $TMPEXPL
    for keeper in `cat $KEEPS`
    do
      cat $TMPEXPL | sed -e "/^$keeper$/d" > $WRKLIST
      rm $TMPEXPL
      cp $WRKLIST $TMPEXPL
    done
    rm $TMPEXPL
      ;;
      n)
    rm $KEEPS
    touch $KEEPS
    cp $EXPLINST $WRKLIST
      ;;
      *)
    echo "==> You must choose y or n"
    echo "==> Exiting."
    exit 1
      ;;
    esac
  else
    fileCheck $KEEPS
    cp $EXPLINST $WRKLIST
  fi
else
  fileCheck $KEEPS
  cp $EXPLINST $WRKLIST
fi
echo
}

#WORKING FILE CREATOR
fileCheck () {
if [ -f $1 ]
then
  rm $1
fi
touch $1
}

#EXPLICITY INSTALLED LIST GENERATOR
getExplInst () {
pacman -Qe | cut -d " " -f1 > $EXPLINST
}

#QUERY PACKAGE
queryKeep () {
for pkg in `cat $WRKLIST`
do
  echo -e "==> Do you want to keep \033[1m$pkg\033[0m [y/n/i/q/d]"
  read action
  queryAction $action
  echo
done
}

#PROCESS QUERY RESPONSE
queryAction () {
case $action in
  y)
    echo "==> Keeping $pkg"
    echo $pkg >> $KEEPS
  ;;
  n)
    echo "==> Removing $pkg"
    echo $pkg >> $REMS
  ;;
  i)
    echo "==> $1 Info"
    pacman -Qi $pkg
    echo -e "==> Do you want to keep \033[1m$pkg\033[0m [y/n/i/q/d]"
    read action
    queryAction $action
  ;;
  q)
    echo "==> Exiting"
    exit 0
  ;;
  d)
    echo "==> Done with selection"
    break
  ;;
  *|"")
    echo "==> y=yes n=no i=info q=quit d=done with selection"
    echo "==> Choose y/n/i/q/d"
    read action
    queryAction $action
  ;;
esac
}

#CHECK FOR DEPENDENCIES
depCheck () {
echo
echo "==> Checking dependencies..."
cp $REMS $SAFEREMS
cp $EXPLINST $DEPLIST
for rmpkg in `cat $SAFEREMS`
do
  cat $DEPLIST | sed -e "/^$rmpkg$/d" > $TMPDEPLIST
  rm $DEPLIST
  mv $TMPDEPLIST $DEPLIST
done

for pkg in `cat $DEPLIST`
do
  deps=`cat /var/lib/pacman/local/$pkg-*/depends | sed '0,/%OPTDEPENDS%/!d' | grep -v "^%\|^$" | sed ':a;N;$!ba;s/\n/ /g'`
  for dirtydep in $deps
  do
    cleandep=`echo $dirtydep | cut -d "<" -f1 | cut -d ">" -f1 | cut -d "=" -f1`
    cat $SAFEREMS | sed -e "/^$cleandep$/d" > $TMPREMS
    rm $SAFEREMS
    mv $TMPREMS $SAFEREMS
  done
done
echo "==> Dependency check completed."
}

#REVIEW PACKAGES TO REMOVE
review () {
queue=`cat $SAFEREMS`

if [ -z "$queue" ]
then 
  echo "==> No packages selected for removal"
  echo "==> Exiting"
else
  echo
  echo "==> The following packages are selected for removal:"
  echo "$queue"
  echo "==> Do you wish to modify this selection? [y/n/q]"
  read review
  case $review in
    y)
      rm $WRKLIST
      rm $REMS
      mv $SAFEREMS $WRKLIST
      queryKeep
      depCheck
      review
    ;;
    n)
      echo "==> Proceeding to remove packages and orphans..."
      sudo pacman -Rsn `cat $SAFEREMS`
    ;;
    q)
      echo "==> Exiting."
    ;;
    *)
      echo "==> You must choose y/n/q"
      review
    ;;
  esac
fi
}

#CLEAN UP WORKING FILES
cleanUp () {
rm $EXPLINST
rm $REMS
rm $SAFEREMS
rm $WRKLIST
rm $DEPLIST
}
#/FUNCTIONS

#--RUN--
set -e
checks
queryKeep
depCheck
review
cleanUp
#/RUN
