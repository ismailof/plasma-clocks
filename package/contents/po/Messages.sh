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


echo "Extracting messages from $(realpath ${BASEDIR})"
cd ${BASEDIR}

# see above on sorting
find . -name '*.qml' -o -name '*.js' | sort > ${WDIR}/infiles.list

cd ${WDIR}
xgettext --from-code=UTF-8 -C -kde -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 -ktr2i18n:1 \
	-kI18N_NOOP:1 -kI18N_NOOP2:1c,2 -kaliasLocale -kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3 \
	--msgid-bugs-address="${BUGADDR}" \
	--files-from=infiles.list -D ${BASEDIR} -D ${WDIR} -o ${PROJECT}.pot || { echo "error while calling xgettext. aborting."; exit 1; }

catalogs=$(find . -name '*.po')
echo "Merging translations: ${catalogs}"
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

echo "Cleaning up"
cd ${WDIR}
rm infiles.list

echo "Done"
