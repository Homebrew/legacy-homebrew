class Libfixposix < Formula
  desc "Thin wrapper over POSIX syscalls"
  homepage "https://github.com/sionescu/libfixposix"
  url "https://github.com/sionescu/libfixposix/archive/v0.3.0.tar.gz"
  sha256 "9fda592842c28b3beb2707b908b2bdca1982c0a37572fad5cfce2ab1ba07f6d3"
  head "https://github.com/sionescu/libfixposix.git"

  bottle do
    cellar :any
    sha256 "4dd4b064155ee9b88484ecf569c36e952f8683ddb74741ae028549be9858686f" => :el_capitan
    sha256 "6645923b4c6f88eb3dab48c5be590ca8968d8fea1899eb704a3ed7ec8712300f" => :yosemite
    sha256 "60ab4f710398631e22024db60e54fe1075b0f1aa9bab4ca8e896f9f1229d13fb" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"mxstemp.c").write <<-EOS.undent
      #include <stdio.h>

      #include <lfp.h>

      int main(void)
      {
          fd_set rset, wset, eset;

          lfp_fd_zero(&rset);
          lfp_fd_zero(&wset);
          lfp_fd_zero(&eset);

          for(unsigned i = 0; i < FD_SETSIZE; i++) {
              if(lfp_fd_isset(i, &rset)) {
                  printf("%d ", i);
              }
          }

          return 0;
      }
    EOS
    system ENV.cc, "mxstemp.c", lib/"libfixposix.dylib", "-I#{include}", "-L#{lib}", "-o", "mxstemp"
    system "./mxstemp"
  end
end
