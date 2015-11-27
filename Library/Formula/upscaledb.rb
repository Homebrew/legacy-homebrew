class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "http://upscaledb.com/"
  url "http://files.upscaledb.com/dl/upscaledb-2.1.12.tar.gz"
  sha256 "f68c7e7b8f5aaf41ab47d60e351db35506f96ebf8be2ad695a0d8a12035001df"

  bottle do
    sha256 "27151089e42c383b22ddf599b0d9f42498e8b30564b8306f80ceab16ea79741f" => :yosemite
    sha256 "ae81107767d2954c978573edc85e0b50b84ba1b829d016d5ca898ce64fdd1046" => :mavericks
    sha256 "5c2645a8d1f51613bfa0aa05f1045836f5b0117d674af297878ca5e78bb136a6" => :mountain_lion
  end

  head do
    url "https://github.com/cruppstahl/upscaledb.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-java", "Do not build the Java wrapper"
  option "without-remote", "Disable access to remote databases"

  depends_on "boost"
  depends_on "gnutls"
  depends_on "openssl"
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
        system "make", "libuv.dylib", "SO_LDFLAGS=-Wl,-install_name,#{libexec}/libuv/lib/libuv.dylib"
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
    # https://github.com/cruppstahl/upscaledb/commit/b435cc4fdfd8750aa3e717321608ef0c059d15ca
    mv include/"ham", include/"ups" if build.stable?

    share.install "samples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lupscaledb",
           share/"samples/db1.c", "-o", "test"
    system "./test"
  end
end
