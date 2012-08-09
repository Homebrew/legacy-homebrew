require 'formula'

def needs_universal_python?
  ARGV.build_universal? and not ARGV.include? "--without-python"
end

class UniversalPython < Requirement
  def message; <<-EOS.undent
    A universal build was requested, but Python is not a universal build

    Boost compiles against the Python it finds in the path; if this Python
    is not a universal build then linking will likely fail.
    EOS
  end
  def satisfied?
    archs_for_command("python").universal?
  end
end

class Boost < Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.49.0/boost_1_49_0.tar.bz2'
  sha1 '26a52840e9d12f829e3008589abf0a925ce88524'

  head 'http://svn.boost.org/svn/boost/trunk'

  bottle do
    sha1 '6b706780670a8bec5b3e0355f5dfeeaa37d9a41e' => :lion
    sha1 '46945515d520009fbbc101e4ae19f28db1433752' => :snowleopard
  end

  option :universal
  option 'with-mpi', 'Enable MPI support'
  option 'without-python', 'Build without Python'
  option 'with-icu', 'Build regexp engine with icu support'

  depends_on UniversalPython.new if needs_universal_python?
  depends_on "icu4c" if build.include? "--with-icu"

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
    #   /usr/local/libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    inreplace 'tools/build/v2/tools/darwin.jam', '-install_name "', "-install_name \"#{HOMEBREW_PREFIX}/lib/"

    # Force boost to compile using the appropriate GCC version
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n" if build.include? '--with-mpi'
    end

    # we specify libdir too because the script is apparently broken
    bargs = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if build.include? "--with-icu"
      icu4c_prefix = Formula.factory('icu4c').prefix
      bargs << "--with-icu=#{icu4c_prefix}"
    end

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "threading=multi",
            "install"]

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if build.universal?
    args << "--without-python" if build.include? "--without-python"

    system "./bootstrap.sh", *bargs
    system "./bjam", *args
  end
end
