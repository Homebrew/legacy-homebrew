require 'formula'

class UniversalPython < Requirement
  satisfy(:build_env => false) { archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A universal build was requested, but Python is not a universal build

    Boost compiles against the Python it finds in the path; if this Python
    is not a universal build then linking will likely fail.
    EOS
  end
end

class Boost < Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.54.0/boost_1_54_0.tar.bz2'
  sha1 '230782c7219882d0fab5f1effbe86edb85238bf4'

  head 'http://svn.boost.org/svn/boost/trunk'

  bottle do
    cellar :any
    sha1 '767a67f4400e5273db3443e10a6e07704b4cbd0f' => :mountain_lion
    sha1 '5f487b4a1d131722dd673d7ee2de418adf3b5322' => :lion
    sha1 'cedd9bd34e6dbebc073beeb12fb3aa7a3cb5ecb6' => :snow_leopard
  end

  env :userpaths

  option :universal
  option 'with-icu', 'Build regexp engine with icu support'
  option 'with-c++11', 'Compile using Clang, std=c++11 and stdlib=libc++' if MacOS.version >= :lion
  option 'without-single', 'Disable building single-threading variant'
  option 'without-static', 'Disable building static library variant'

  depends_on :python => :recommended
  depends_on UniversalPython if build.universal? and build.with? "python"
  depends_on "icu4c" if build.with? 'icu'
  depends_on :mpi => [:cc, :cxx, :optional]

  fails_with :llvm do
    build 2335
    cause "Dropped arguments to functions when linking with boost"
  end

  def patches
    # upstream backported patches for 1.54.0: http://www.boost.org/patches
    [
      'http://www.boost.org/patches/1_54_0/001-coroutine.patch',
      'http://www.boost.org/patches/1_54_0/002-date-time.patch',
      'http://www.boost.org/patches/1_54_0/003-log.patch',
      'http://www.boost.org/patches/1_54_0/004-thread.patch'
    ]
  end

  def pour_bottle?
    # Don't use the bottle if there is a Homebrew python installed as users
    # will probably want to link against that instead.
    not Formula.factory('python').installed?
  end

  def install
    # https://svn.boost.org/trac/boost/ticket/8841
    if build.with? 'mpi' and !build.without? 'single'
      onoe <<-EOS.undent
        Building MPI support for both single and multi-threaded flavors
        is not supported.  Please use '--with-mpi' together with
        '--disable-single'.
      EOS
      exit -1
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
    #   /usr/local/lib/libboost_system-mt.dylib (compatibility version 0.0.0, current version 0.0.0)
    inreplace 'tools/build/v2/tools/darwin.jam', '-install_name "', "-install_name \"#{HOMEBREW_PREFIX}/lib/"

    # boost will try to use cc, even if we'd rather it use, say, gcc-4.2
    inreplace 'tools/build/v2/engine/build.sh', 'BOOST_JAM_CC=cc', "BOOST_JAM_CC=#{ENV.cc}"
    inreplace 'tools/build/v2/engine/build.jam', 'toolset darwin cc', "toolset darwin #{ENV.cc}"

    # Force boost to compile using the appropriate GCC version
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n" if build.with? 'mpi'
    end

    # we specify libdir too because the script is apparently broken
    bargs = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    bargs << "--with-toolset=clang" if build.with? "c++11"

    if build.with? 'icu'
      icu4c_prefix = Formula.factory('icu4c').opt_prefix
      bargs << "--with-icu=#{icu4c_prefix}"
    else
      bargs << '--without-icu'
    end

    # The context library is implemented as x86_64 ASM, so it
    # won't build on PPC or 32-bit builds
    # see https://github.com/mxcl/homebrew/issues/17646
    if Hardware::CPU.type == :ppc || Hardware::CPU.bits == 32 || build.universal?
      bargs << "--without-libraries=context"
      # The coroutine library depends on the context library.
      bargs << "--without-libraries=coroutine"
    end

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    bargs << "--without-libraries=log" if MacOS.version <= :snow_leopard

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "install"]

    if build.include? 'without-single'
      args << "threading=multi"
    else
      args << "threading=multi,single"
    end

    if build.include? 'without-static'
      args << "link=shared"
    else
      args << "link=shared,static"
    end

    if MacOS.version >= :lion and build.with? 'c++11'
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
    args << "--without-python" if build.without? 'python'

    system "./bootstrap.sh", *bargs
    system "./b2", *args
  end
end
