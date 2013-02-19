#!/bin/bash
# auto-configures diy source packages for use with homebrew

# Message for security and/or debugging
echo "This script is being run as $0 in `pwd`."

# basic check for Homebrew
echo "Testing to make sure Homebrew is installed..." # Progress indicator
BREW_PATH=`which brew`
if [ -z "$BREW_PATH" ]; then
	echo "==> Error: Homebrew is required to use this script." # Progress indicator
	exit 0
else
	echo "==> Homebrew found at $BREW_PATH" # Progress indicator
fi

# brew diy requires a version number to be appended to the end of the directory to set the name of the Cellar directory properly
echo "Testing to make sure the directory is versioned..." # Progress indicator
BREW_DIY_RESULTS=`brew diy`
if [ "$BREW_DIY_RESULTS" = "Error: Couldn't determine version, try --set-version" ]; then
	echo "==> Directory doesn't seem to be versioned, adding placeholder version number to directory name so that \"brew diy\" will work..." # Progress indicator
	cd ../
	mv "$OLDPWD" "$OLDPWD"-0.0.1
	cd "$OLDPWD"-0.0.1
	BREW_DIY_RESULTS=`brew diy` # Reset variable
	echo "==> Your directory is now named $PWD (If you dislike the placeholder version number, feel free to change it manually)" # Progress indicator
else
	echo "==> Directory is already versioned! Moving on..." # Progress indicator
fi

# This following block is a way to create the Makefile.am file needed for brew to know we're using autotools
echo "Checking to see if Makefile.am exists and if it includes any possibly existing m4 directory in its ACLOCAL_AMFLAGS entry..." # Progress indicator
if [ -d ./m4 ]; then
	echo "==> m4 directory found, performing rest of check..." # Progress indicator
	if [ -e ./Makefile.am ]; then
		echo "====> Makefile.am found, checking to see if it has an entry for ACLOCAL_AMFLAGS..." # Progress indicator
		ACLOCAL_AMFLAGS=`cat makefile.am | grep "ACLOCAL_AMFLAGS = "`
		if [ -z "$ACLOCAL_AMFLAGS" ]; then
			echo "======> ACLOCAL_AMFLAGS not found in Makefile.am, adding it..." # Progress indicator
			echo "ACLOCAL_AMFLAGS = -I m4" >> Makefile.am
		else
			echo "======> The ACLOCAL_AMFLAGS entry is \"$ACLOCAL_AMFLAGS\"" # Progress indicator
		fi
	else
		echo "====> Makefile.am not found, creating it with ACLOCAL_AMFLAGS set..." # Progress indicator
		echo "ACLOCAL_AMFLAGS = -I m4" > Makefile.am
	fi
else
	echo "==> m4 directory not found, not bothering with the rest of this step..." # Progress indicator
fi

# The following step actually does stuff
echo "Getting ready to finally configure now..." # Progress indicator
if [ -e ./Makefile.am ]; then
	echo "==> Using autotools build system..." # Progress indicator
	if [ -e ./Makefile.in ]; then
		echo "====> Looks like automake has already been run. Moving on..." # Progress indicator
		touch ./Makefile.in
	else
		echo "====> Running automake..." # Progress indicator
		automake --add-missing
		touch ./Makefile.in
	fi
	if [ -x ./configure ]; then
		echo "====> Actually configuring now..." # Progress indicator
		./configure $BREW_DIY_RESULTS
	elif [ -e ./configure.ac ]; then
		echo "====> Running autoconf, then actually configuring..." # Progress indicator
		autoconf && ./configure $BREW_DIY_RESULTS
	else
		echo "====> Failed to find or generate a proper configure script." # Progress indicator
		exit 0
	fi
elif [ -e ./CmakeLists.txt ]; then
	echo "==> Running Cmake now..."# Progress indicator
	Cmake . $BREW_DIY_RESULTS
else
	echo "==> Failed to detect build system." # Progress indicator
	exit 0
fi

# A final status message
echo "Checking to make sure we finished properly..." # Progress indicator
if [ -e ./Makefile ]; then
	echo "==> Found a makefile, checking to make sure it actually came from configuring..." # Progress indicator
	if [ -e ./config.status ]; then
		echo "====> Successfully configured with autotools for use with Homebrew! Type \"make install\" to install into your Homebrew Cellar. After that you can \"brew link\" it." # Progress indicator
	elif [ -e ./CmakeCache.txt ]; then
		echo "====> Successfully configured with Cmake for use with Homebrew! Type \"make install\" to install into your Homebrew Cellar. After that you can \"brew link\" it." # Progress indicator
	else
		echo "====> Cannot confirm that the makefile was a result of configuring. You can still use it with \"make\", but be careful." # Progress indicator
	fi
else
	echo "==> `basename $0` seems to have failed." # Progress indicator
fi

