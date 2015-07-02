class FbthriftCompiler < Formula
  desc "IDL compiler from Facebook's Thrift, an RPC system"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v0.28.0.tar.gz"
  version "28.0"
  sha256 "1aa577d313c24950be1f0bb9681c4c959ce010a7ba298870c3f9a5b54c6cdc61"

  head "https://github.com/facebook/fbthrift.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "glog"
  depends_on "boost"
  depends_on "folly"

  # 1. Thrift's configure.ac conflates the cpp runtime with the compiler. Even
  # if we specify `--without-cpp` to skip the checks for e.g. numa which isn't
  # available on OSX, the configure ends up forcing WITH_CPP=true anyway which
  # tries to build the cpp runtime in lib.  We work around that by explicitly
  # removing lib from the list of SUBDIRS to process.
  # 2. The build process for the python chunk of the compiler doesn't really
  # work too well. But that's ok, because it's optional, and the cpp half
  # doesn't know how to call the python half on OSX anyway. So exclude that
  # too.
  # For details, see:
  #  https://github.com/facebook/fbthrift/issues/102
  #  https://github.com/facebook/fbthrift/issues/62
  #  https://github.com/facebook/fbthrift/issues/50
  #  https://github.com/facebook/fbthrift/issues/21
  patch :p1, :DATA

  def install
    cd "thrift" do
      system "autoreconf", "-i"

      system "./configure",
          "--disable-debug",
          "--disable-dependency-tracking",
          "--disable-silent-rules",
          "--prefix=#{prefix}",
          "--without-python", # see patch comment above
          "--without-cpp" # see patch comment above

      system "make", "install"
    end
  end

  test do
    (testpath/"basic.thrift").write <<-EOF.undent
      enum MyEnum { Val1, Val2 }
      struct MyStruct {
        1: i64 f1,
        2: string f2,
      }
      service MyService {
        string doThing(1: MyStruct arg);
      }
    EOF

    system "#{bin}/thrift1", "-gen", "java", (testpath/"basic.thrift")

    %w{MyEnum.java MyStruct.java MyService.java}.each do |file|
      assert (testpath/"gen-java"/file).exist?
    end
  end
end

__END__
--- a/thrift/Makefile.am	2014-10-10 14:54:23.000000000 -0700
+++ b/thrift/Makefile.am	2014-10-10 14:54:27.000000000 -0700
@@ -19,7 +19,7 @@
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = compiler lib
+SUBDIRS = compiler
 
 
 dist-hook:
--- a/thrift/compiler/Makefile.am	2014-10-10 14:39:43.000000000 -0700
+++ b/thrift/compiler/Makefile.am	2014-10-10 14:39:52.000000000 -0700
@@ -25,8 +25,6 @@
 LIBS =
 BUILT_SOURCES =
 
-SUBDIRS = . py
-
 bin_PROGRAMS = thrift1
 
 noinst_LTLIBRARIES = libparse.la libthriftcompilerbase.la
