class Hamsterdb < Formula
  homepage "http://hamsterdb.com"
  url "http://files.hamsterdb.com/dl/hamsterdb-2.1.10.tar.gz"
  sha256 "8fced5607847e234133b2baa379e7ff3d763ffa51546b27f1e3c5f1aef33493e"

  head do
    url "https://github.com/cruppstahl/hamsterdb.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "b4b9b5642f17f3fd22f435309c6bfdb3eb4be13a" => :yosemite
    sha1 "d8766c2c04563e2e471bed85e43945bcd402c4dc" => :mavericks
    sha1 "f08ff2613c4caaba89d21d8bb3ddc5be332847c1" => :mountain_lion
  end

  option "without-java", "Do not build the Java wrapper"
  option "without-remote", "Disable access to remote databases"

  depends_on "boost"
  depends_on "gnutls"
  depends_on :java => :recommended
  depends_on "protobuf" if build.with? "remote"

  resource "libuv" do
    url "https://github.com/libuv/libuv/archive/v0.10.36.tar.gz"
    sha256 "421087044cab642f038c190f180d96d6a1157be89adb4630881930495b8f5228"
  end

  fails_with :clang do
    build 503
    cause "error: member access into incomplete type 'const std::type_info"
  end
  fails_with :llvm do
    build 2336
    cause "error: forward declaration of 'const struct std::type_info'"
  end

  def install
    system "./bootstrap.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "java"
      args << "JDK=#{ENV["JAVA_HOME"]}"
    else
      args << "--disable-java"
    end

    if build.with? "remote"
      resource("libuv").stage do
        system "make", "libuv.dylib"
        (libexec/"libuv/lib").install "libuv.dylib"
        (libexec/"libuv").install "include"
      end

      ENV.prepend "LDFLAGS", "-L#{libexec}/libuv/lib"
      ENV.prepend "CFLAGS", "-I#{libexec}/libuv/include"
      ENV.prepend "CPPFLAGS", "-I#{libexec}/libuv/include"
    else
      args << "--disable-remote"
    end

    system "./configure", *args
    system "make", "install"

    share.install "samples"
  end

  test do
    system bin/"ham_info", "-h"
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lhamsterdb",
           share/"samples/db1.c", "-o", "test"
    system "./test"
  end
end
