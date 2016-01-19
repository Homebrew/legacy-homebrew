class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "http://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.bz2"
  sha256 "686affff989ac2488f79a97b9479efb9f2abae035b5ed4d8226de6857933fd3b"
  revision 1

  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "2f7a84ca6edf978eef4fc23b6f1d4c540b343f5941f068dfc59eb1c103f01dc7" => :el_capitan
    sha256 "cdea70d456a842617a9aa59dd297da2e63e95eddd74c1fa302eedfed21a51538" => :yosemite
    sha256 "1a7feb411f4e89237fc212cab55c0f3acd1abe86a887069236ef6e7c58bdd82a" => :mavericks
  end

  # Handle compile failure with boost/graph/adjacency_matrix.hpp
  # https://github.com/Homebrew/homebrew/pull/48262
  # https://svn.boost.org/trac/boost/ticket/11880
  # patch derived from https://github.com/boostorg/graph/commit/1d5f43d
  patch :DATA

  env :userpaths

  option :universal
  option "with-icu4c", "Build regexp engine with icu support"
  option "without-single", "Disable building single-threading variant"
  option "without-static", "Disable building static library variant"
  option "with-mpi", "Build with MPI support"
  option :cxx11

  deprecated_option "with-icu" => "with-icu4c"

  if build.cxx11?
    depends_on "icu4c" => [:optional, "c++11"]
    depends_on "open-mpi" => "c++11" if build.with? "mpi"
  else
    depends_on "icu4c" => :optional
    depends_on :mpi => [:cc, :cxx, :optional]
  end

  fails_with :llvm do
    build 2335
    cause "Dropped arguments to functions when linking with boost"
  end

  needs :cxx11 if build.cxx11?

  def install
    # https://svn.boost.org/trac/boost/ticket/8841
    if build.with?("mpi") && build.with?("single")
      raise <<-EOS.undent
        Building MPI support for both single and multi-threaded flavors
        is not supported.  Please use "--with-mpi" together with
        "--without-single".
      EOS
    end

    ENV.universal_binary if build.universal?

    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n" if build.with? "mpi"
    end

    # libdir should be set by --prefix but isn't
    bootstrap_args = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if build.with? "icu4c"
      icu4c_prefix = Formula["icu4c"].opt_prefix
      bootstrap_args << "--with-icu=#{icu4c_prefix}"
    else
      bootstrap_args << "--without-icu"
    end

    # Handle libraries that will not be built.
    without_libraries = ["python"]

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
    without_libraries << "mpi" if build.without? "mpi"

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python
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

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  def caveats
    s = ""
    # ENV.compiler doesn't exist in caveats. Check library availability
    # instead.
    if Dir["#{lib}/libboost_log*"].empty?
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

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <boost/algorithm/string.hpp>
      #include <string>
      #include <vector>
      #include <assert.h>
      using namespace boost::algorithm;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-lboost_system", "-o", "test"
    system "./test"
  end
end

__END__
diff -Nur boost_1_60_0/boost/graph/adjacency_matrix.hpp boost_1_60_0-patched/boost/graph/adjacency_matrix.hpp
--- boost_1_60_0/boost/graph/adjacency_matrix.hpp	2015-10-23 05:50:19.000000000 -0700
+++ boost_1_60_0-patched/boost/graph/adjacency_matrix.hpp	2016-01-19 14:03:29.000000000 -0800
@@ -443,7 +443,7 @@
     // graph type. Instead, use directedS, which also provides the
     // functionality required for a Bidirectional Graph (in_edges,
     // in_degree, etc.).
-    BOOST_STATIC_ASSERT(type_traits::ice_not<(is_same<Directed, bidirectionalS>::value)>::value);
+    BOOST_STATIC_ASSERT(!(is_same<Directed, bidirectionalS>::value));

     typedef typename mpl::if_<is_directed,
                                     bidirectional_tag, undirected_tag>::type
