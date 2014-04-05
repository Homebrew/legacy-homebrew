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
  url 'https://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2'
  sha1 'cef9a0cc7084b1d639e06cd3bc34e4251524c840'
  revision 1

  head 'https://github.com/boostorg/boost.git'

  bottle do
    cellar :any
    sha1 "8febaa2cf64152663551ae34a30f3030a1c1c023" => :mavericks
    sha1 "1567fbf688e212f0e5a24d246fa386ea99cab5ae" => :mountain_lion
    sha1 "2ed8000a0abb993fdd2985383eae9126c4170f5e" => :lion
  end

  env :userpaths

  option :universal
  option 'with-icu', 'Build regexp engine with icu support'
  option 'without-single', 'Disable building single-threading variant'
  option 'without-static', 'Disable building static library variant'
  option 'with-mpi', 'Build with MPI support'
  option :cxx11

  depends_on :python => :recommended
  depends_on UniversalPython if build.universal? and build.with? "python"

  if build.with? 'icu'
    if build.cxx11?
      depends_on 'icu4c' => 'c++11'
    else
      depends_on 'icu4c'
    end
  end

  if build.with? 'mpi'
    if build.cxx11?
      depends_on 'open-mpi' => 'c++11'
    else
      depends_on :mpi => [:cc, :cxx, :optional]
    end
  end

  odie 'boost: --with-c++11 has been renamed to --c++11' if build.with? 'c++11'

  stable do
    # Patches boost::atomic for LLVM 3.4 as it is used on OS X 10.9 with Xcode 5.1
    # https://github.com/Homebrew/homebrew/issues/27396
    # https://github.com/Homebrew/homebrew/pull/27436
    patch :p2 do
      url "https://github.com/boostorg/atomic/commit/6bb71fdd.patch"
      sha1 "8dfaf4d123f1161c83fff91d4ef70b8f95a4ef94"
    end

    patch :p2 do
      url "https://github.com/boostorg/atomic/commit/e4bde20f.patch"
      sha1 "f206e7261d00503788ae8ec3a0635ced8a816293"
    end
  end

  fails_with :llvm do
    build 2335
    cause "Dropped arguments to functions when linking with boost"
  end

  def install
    # https://svn.boost.org/trac/boost/ticket/8841
    if build.with? 'mpi' and build.with? 'single'
      raise <<-EOS.undent
        Building MPI support for both single and multi-threaded flavors
        is not supported.  Please use '--with-mpi' together with
        '--without-single'.
      EOS
    end

    if build.cxx11? and build.with? 'mpi' and build.with? 'python'
      raise <<-EOS.undent
        Building MPI support for Python using C++11 mode results in
        failure and hence disabled.  Please don't use this combination
        of options.
      EOS
    end

    ENV.universal_binary if build.universal?

    # Force boost to compile using the appropriate GCC version.
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n" if build.with? 'mpi'
    end

    # we specify libdir too because the script is apparently broken
    bargs = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if build.with? 'icu'
      icu4c_prefix = Formula['icu4c'].opt_prefix
      bargs << "--with-icu=#{icu4c_prefix}"
    else
      bargs << '--without-icu'
    end

    # Handle libraries that will not be built.
    without_libraries = []

    # The context library is implemented as x86_64 ASM, so it
    # won't build on PPC or 32-bit builds
    # see https://github.com/Homebrew/homebrew/issues/17646
    if Hardware::CPU.ppc? || Hardware::CPU.is_32_bit? || build.universal?
      without_libraries << "context"
      # The coroutine library depends on the context library.
      without_libraries << "coroutine"
    end

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc || ENV.compiler == :llvm

    without_libraries << "python" if build.without? 'python'
    without_libraries << "mpi" if build.without? 'mpi'

    bargs << "--without-libraries=#{without_libraries.join(',')}"

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "install"]

    if build.with? "single"
      args << "threading=multi,single"
    else
      args << "threading=multi"
    end

    if build.with? "static"
      args << "link=shared,static"
    else
      args << "link=shared"
    end

    args << "address-model=32_64" << "architecture=x86" << "pch=off" if build.universal?

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    if build.cxx11?
      args << "cxxflags=-std=c++11"
      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end
    end

    system "./bootstrap.sh", *bargs
    system "./b2", *args
  end

  def caveats
    s = ''
    # ENV.compiler doesn't exist in caveats. Check library availability
    # instead.
    if Dir.glob("#{lib}/libboost_log*").empty?
      s += <<-EOS.undent

      Building of Boost.Log is disabled because it requires newer GCC or Clang.
      EOS
    end

    if Hardware::CPU.ppc? || Hardware::CPU.is_32_bit? || build.universal?
      s += <<-EOS.undent

      Building of Boost.Context and Boost.Coroutine is disabled as they are
      only supported on x86_64.
      EOS
    end

    s
  end
end
