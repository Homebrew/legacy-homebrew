require 'formula'

class Boost <Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.42.0/boost_1_42_0.tar.bz2'
  md5 '7bf3b4eb841b62ffb0ade2b82218ebe6'

  def patches
    { :p0 => DATA }
  end

  def install
    fails_with_llvm "the standard llvm-gcc causes errors with dropped arugments "+
                    "to functions when linking with the boost library"

    # Not sure about this, but added since macports has it
    mkdir 'libs/random/build'
    open("libs/random/build/Jamfile.v2", "w") do |file|
      file.write <<-EOF.gsub(/^\s+/, '')
        # Copyright (c) 2006 Tiziano Mueller
        #
        # Use, modification and distribution of the file is subject to the
        # Boost Software License, Version 1.0.
        # (See at http://www.boost.org/LICENSE_1_0.txt)


        project boost/random
        	: source-location ../ ;

        SOURCES = random_device ;

        lib boost_random
        	: $(SOURCES).cpp
        	: <link>shared:<define>BOOST_RANDOM_DYN_LINK=1 ;
      EOF
    end

    # Adjust the name the libs are installed under to include the path to the
    # Homebrew lib directory.  It has the following effect:
    #
    # otool -L `which mkvmerge`
    # /Users/cehoffman/.homebrew/bin/mkvmerge:
    #   /Users/cehoffman/.homebrew/Cellar/libvorbis/1.2.3/lib/libvorbis.0.dylib (compatibility version 5.0.0, current version 5.3.0)
    #   /Users/cehoffman/.homebrew/Cellar/libogg/1.1.4/lib/libogg.0.dylib (compatibility version 7.0.0, current version 7.0.0)
    #   /usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.3)
    #   /usr/lib/libbz2.1.0.dylib (compatibility version 1.0.0, current version 1.0.5)
    #   /usr/lib/libexpat.1.dylib (compatibility version 7.0.0, current version 7.2.0)
    #   /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
    #   libboost_regex-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   libboost_filesystem-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /usr/lib/libstdc++.6.dylib (compatibility version 7.0.0, current version 7.9.0)
    #   /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.0.0)
    #
    # becomes
    #
    # /Users/cehoffman/.homebrew/bin/mkvmerge:
    #   /Users/cehoffman/.homebrew/Cellar/libvorbis/1.2.3/lib/libvorbis.0.dylib (compatibility version 5.0.0, current version 5.3.0)
    #   /Users/cehoffman/.homebrew/Cellar/libogg/1.1.4/lib/libogg.0.dylib (compatibility version 7.0.0, current version 7.0.0)
    #   /usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.3)
    #   /usr/lib/libbz2.1.0.dylib (compatibility version 1.0.0, current version 1.0.5)
    #   /usr/lib/libexpat.1.dylib (compatibility version 7.0.0, current version 7.2.0)
    #   /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
    #   /Users/cehoffman/.homebrew/lib/libboost_regex-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /Users/cehoffman/.homebrew/lib/libboost_filesystem-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /Users/cehoffman/.homebrew/lib/libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /usr/lib/libstdc++.6.dylib (compatibility version 7.0.0, current version 7.9.0)
    #   /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 125.0.0)
    #
    # Hence executables that link against the boost library will work when
    # Homebrew is installed in a non standard location
    inreplace 'tools/build/v2/tools/darwin.jam', '-install_name "', "-install_name \"#{`brew --prefix`.strip}/lib/"

    # Force boost to compile using the GCC 4.2 compiler
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV['CXX']} ;\n"
    end

    # we specify libdir too because the script is apparently broken
    system "./bootstrap.sh --prefix='#{prefix}' --libdir='#{lib}'"
    system "./bjam -j#{Hardware.processor_count} --layout=tagged --prefix='#{prefix}' --libdir='#{lib}' --user-config=user-config.jam threading=multi install"
  end
end

__END__
===================================================================
--- libs/random/random_device.cpp.orig	2009-06-11 15:27:21.000000000 +0200
+++ libs/random/random_device.cpp	2009-06-11 15:28:01.000000000 +0200
@@ -22,7 +22,7 @@
 #endif


-#if defined(__linux__) || defined (__FreeBSD__)
+#if defined(__linux__) || defined (__FreeBSD__) || defined(__APPLE__)

 // the default is the unlimited capacity device, using some secure hash
 // try "/dev/random" for blocking when the entropy pool has drained
