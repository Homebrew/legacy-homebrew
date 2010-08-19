require 'formula'

class Boost <Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.43.0/boost_1_43_0.tar.bz2'
  md5 'dd49767bfb726b0c774f7db0cef91ed1'

  def install
    fails_with_llvm "the standard llvm-gcc causes errors with dropped arguments "+
                    "to functions when linking with the boost library"

    # Adjust the name the libs are installed under to include the path to the
    # Homebrew lib directory so executables will work when isntalled to a non-/usr/local location.
    #
    # otool -L `which mkvmerge`
    # /usr/local/bin/mkvmerge:
    #   libboost_regex-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   libboost_filesystem-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #
    # becomes:
    #
    # /usr/local/bin/mkvmerge:
    #   /usr/local/lib/libboost_regex-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /usr/local/lib/libboost_filesystem-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    #   /usr/local/libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    inreplace 'tools/build/v2/tools/darwin.jam', '-install_name "', "-install_name \"#{HOMEBREW_PREFIX}/lib/"

    # Force boost to compile using the GCC 4.2 compiler
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV['CXX']} ;\n"
    end

    # we specify libdir too because the script is apparently broken
    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}"
    system "./bjam", "--prefix=#{prefix}",
                     "--libdir=#{lib}",
                     "-j#{Hardware.processor_count}",
                     "--layout=tagged",
                     "--user-config=user-config.jam",
                     "threading=multi",
                     "install"
  end
end
