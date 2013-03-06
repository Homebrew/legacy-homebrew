require 'formula'

def needs_universal_python?
  build.universal? and not build.include? "without-python"
end

def boost_layout
  (build.include? "use-system-layout") ? "system" : "tagged"
end

class UniversalPython < Requirement
  satisfy { archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A universal build was requested, but Python is not a universal build

    Boost compiles against the Python it finds in the path; if this Python
    is not a universal build then linking will likely fail.
    EOS
  end
end

class Boost < Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.53.0/boost_1_53_0.tar.bz2'
  sha1 'e6dd1b62ceed0a51add3dda6f3fc3ce0f636a7f3'

  head 'http://svn.boost.org/svn/boost/trunk'

  bottle do
    sha1 'fda423e53ed998d54c33cc91582c0d5e3e4ff91e' => :mountain_lion
    sha1 '99fec23d1b79a510d8cd1f1f0cbd77cc73b4f4b5' => :lion
    sha1 '15f74640979b95bd327be3b6ca2a5d18878a29ad' => :snow_leopard
  end

  env :userpaths

  option :universal
  option 'with-mpi', 'Enable MPI support'
  option 'without-python', 'Build without Python'
  option 'with-icu', 'Build regexp engine with icu support'
  option 'with-c++11', 'Compile using Clang, std=c++11 and stdlib=libc++' if MacOS.version >= :lion
  option 'use-system-layout', 'Use system layout instead of tagged'

  depends_on UniversalPython if needs_universal_python?
  depends_on "icu4c" if build.include? "with-icu"
  depends_on MPIDependency.new(:cc, :cxx) if build.include? "with-mpi"

  fails_with :llvm do
    build 2335
    cause "Dropped arguments to functions when linking with boost"
  end

  def install
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
    #   /usr/local/lib/libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    inreplace 'tools/build/v2/tools/darwin.jam', '-install_name "', "-install_name \"#{HOMEBREW_PREFIX}/lib/"

    # Force boost to compile using the appropriate GCC version
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n" if build.include? 'with-mpi'
    end

    # we specify libdir too because the script is apparently broken
    bargs = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    bargs << "--with-toolset=clang" if build.include? "with-c++11"

    if build.include? 'with-icu'
      icu4c_prefix = Formula.factory('icu4c').opt_prefix
      bargs << "--with-icu=#{icu4c_prefix}"
    else
      bargs << '--without-icu'
    end

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=#{boost_layout}",
            "--user-config=user-config.jam",
            "threading=multi",
            "install"]

    if MacOS.version >= :lion and build.include? 'with-c++11'
      args << "toolset=clang" << "cxxflags=-std=c++11"
      args << "cxxflags=-stdlib=libc++" << "cxxflags=-fPIC"
      args << "cxxflags=-arch x86_64" if MacOS.prefer_64_bit? or build.universal?
      args << "cxxflags=-arch i386" if !MacOS.prefer_64_bit? or build.universal?
      args << "linkflags=-stdlib=libc++"
      args << "linkflags=-headerpad_max_install_names"
      args << "linkflags=-arch x86_64" if MacOS.prefer_64_bit? or build.universal?
      args << "linkflags=-arch i386" if !MacOS.prefer_64_bit? or build.universal?
    end

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if build.universal?
    args << "--without-python" if build.include? "without-python"

    system "./bootstrap.sh", *bargs
    system "./b2", *args
  end
end
