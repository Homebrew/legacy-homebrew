class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "http://www.libssh2.org/"
  url "http://www.libssh2.org/download/libssh2-1.6.0.tar.gz"
  sha256 "5a202943a34a1d82a1c31f74094f2453c207bf9936093867f41414968c8e8215"

  option "with-libressl", "build with LibreSSL instead of OpenSSL"

  head do
    url "https://github.com/libssh2/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "bc688cb19311bbe1a5dd5ab79f15864b77e1aadc0b042a61c2ac2662481536ac" => :el_capitan
    sha256 "ef02bf38e976c9f786d7bfc743c7bf39ecc2cf634324a2a03dd3767c96f3c44a" => :yosemite
    sha256 "0dfd55ea524c2eea19e2f1baf34cdd609830be488e8dc05787dce353d83765ab" => :mavericks
    sha256 "dca69057eb05d5951ddc11af3078cc4418d81e087fd728f96b989c2b5e5eeba9" => :mountain_lion
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
