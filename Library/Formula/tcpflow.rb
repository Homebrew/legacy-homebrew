class Tcpflow < Formula
  desc "TCP flow recorder"
  homepage "https://github.com/simsong/tcpflow"
  url "http://digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.5.tar.gz"
  sha256 "f39fed437911b858c97937bc902f68f9a690753617abe825411a8483a7f70c72"

  bottle do
    cellar :any
    sha256 "ea92e38288a2fea16c85b9a937951b8ecc0c5ca619ccff050d36590866543356" => :el_capitan
    sha256 "d5e07b6218d3160b27d12e154910286af4f3edbbbc70fe5879852849a046cfae" => :yosemite
    sha256 "b0e5f0a0e6f6fc81be55627483028a578a679d1c342a7127aa3a983983acef1a" => :mavericks
  end

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
