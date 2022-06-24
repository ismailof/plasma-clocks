#!/bin/sh

# based on example found here:
#   https://techbase.kde.org/Development/Tutorials/Localization/i18n_Build_Systems

BUGADDR=""	# MSGID-Bugs

PODIR="$(dirname "$0")"
cd ${PODIR}

BASEDIR=".."	# root of translatable sources
METADATA="../../metadata.json"
LOCALEDIR="../locale"
WDIR=`pwd`		# working dir

PROJECT="plasma_applet_com.github.ismailof.crossword-clock"

catalogs=$(find . -name '*.po')
echo "Merging translations:"
for cat in $catalogs; do
  echo $cat
  msgmerge -o $cat.new $cat ${PROJECT}.pot
  mv $cat.new $cat
done

echo "Generating mo files into $(realpath ${LOCALEDIR})"
catalogs=$(find . -name '*.po')
for cat in $catalogs; do
  echo $cat
	catdir=${LOCALEDIR}/${cat%.*}/LC_MESSAGES
	mkdir -p $catdir
  msgfmt $cat -o $catdir/$PROJECT.mo
done

echo "Done"
