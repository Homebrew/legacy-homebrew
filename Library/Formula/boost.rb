require 'formula'

class Boost < Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.46.1/boost_1_46_1.tar.bz2'
  md5 '7375679575f4c8db605d426fc721d506'

  def options
    [
      ['--with-mpi', "Enables MPI support"],
      ["--universal", "Build universal binaries."]
    ]
  end

  fails_with_llvm "LLVM-GCC causes errors with dropped arguments to functions when linking with boost"

  def install
    if ARGV.include? "--universal"
      archs = archs_for_command("python")
      unless archs.universal?
        opoo "A universal build was requested, but Python is not a universal build"
        puts "Boost compiles against the Python it finds in the path; if this Python"
        puts "is not a universal build then linking will likely fail."
      end
    end

    # Adjust the name the libs are installed under to include the path to the
    # Homebrew lib directory so executables will work when installed to a
    # non-/usr/local location.
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

    # Force boost to compile using the appropriate GCC version
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV['CXX']} ;\n"
      file.write "using mpi ;\n" if ARGV.include? '--with-mpi'
    end

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-j#{Hardware.processor_count}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "threading=multi",
            "install"]

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if ARGV.include? "--universal"

    # we specify libdir too because the script is apparently broken
    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}"
    system "./bjam", *args
  end
end
