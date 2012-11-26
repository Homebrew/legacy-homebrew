#!/bin/sh
# auto-configures diy source packages for use with homebrew

echo "Testing to make sure Homebrew is installed…" # Progress indicator
BREW_PATH=`which brew`
if [ -z "$BREW_PATH" ]; then
	echo "Error: Homebrew is required to use this script."
	exit 0
fi

echo "Testing to make sure the directory is versioned…" # Progress indicator
BREW_DIY_RESULTS=`brew diy`
if [ "$BREW_DIY_RESULTS" = "Error: Couldn't determine version, try --set-version" ]; then
	cd ../
	mv "$OLDPWD" "$OLDPWD"-0.0.1
	cd "$OLDPWD"-0.0.1
	BREW_DIY_RESULTS=`brew diy` # Reset variable
fi

echo "Checking to see if Makefile.am exists and if it includes any possibly existing m4 directory in its ACLOCAL_AMFLAGS entry…" # Progress indicator
if [ -d ./m4 ]; then
	if [ -e ./Makefile.am ]; then
		ACLOCAL_AMFLAGS=`cat makefile.am | grep "ACLOCAL_AMFLAGS = "`
		if [ -z "$ACLOCAL_AMFLAGS" ]; then
		echo "ACLOCAL_AMFLAGS = -I m4" >> Makefile.am
		fi
	else
		echo "ACLOCAL_AMFLAGS = -I m4" > Makefile.am
	fi
fi

echo "Actually configuring now…" # Progress indicator
if [ -e ./Makefile.am ]; then
	if [ -e ./Makefile.in ]; then
		touch ./Makefile.in
	else
		automake --add-missing
		touch ./Makefile.in
	fi
	if [ -x ./configure ]; then
		./configure $BREW_DIY_RESULTS
	elif [ -e ./configure.ac ]; then
		autoconf && ./configure $BREW_DIY_RESULTS
	else
		echo "Failed to find or generate a proper configure script."
		exit 0
	fi
elif [ -e ./CmakeLists.txt ]; then
	Cmake . $BREW_DIY_RESULTS
else
	echo "Failed to detect build system."
	exit 0
fi

echo "Successfully configured for use with Homebrew! Type \"make install\" to install into your Homebrew Cellar. After that you can \"brew link\" it."

