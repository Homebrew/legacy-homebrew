class Libssh2 < Formula
  homepage "http://www.libssh2.org/"
  url "http://www.libssh2.org/download/libssh2-1.5.0.tar.gz"
  sha256 "83196badd6868f5b926bdac8017a6f90fb8a90b16652d3bf02df0330d573d0fc"

  option "with-libressl", "build with LibreSSL instead of OpenSSL"

  head do
    url "git://git.libssh2.org/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "6e9fd52d513692ea5db968de524dbe2b81e2f018" => :yosemite
    sha1 "bbe16ac0d85f7aed7794ba5f2220aa3a533298aa" => :mavericks
    sha1 "6de15a0a9400554c51858092e0276bb9ddd15c42" => :mountain_lion
  end

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
    ]

    if build.with? "libressl"
      args << "--with-libssl-prefix=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-libssl-prefix=#{Formula["openssl"].opt_prefix}"
    end

    system "./buildconf" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
