class Tcpflow < Formula
  desc "TCP flow recorder"
  homepage "https://github.com/simsong/tcpflow"
  url "http://digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.5.tar.gz"
  sha256 "f39fed437911b858c97937bc902f68f9a690753617abe825411a8483a7f70c72"

  head do
    url "https://github.com/simsong/tcpflow.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "sqlite" if MacOS.version < :lion
  depends_on "openssl"

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
