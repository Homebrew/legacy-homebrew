require "formula"

class Hydra < Formula
  homepage "https://www.thc.org/thc-hydra/"
  url "https://www.thc.org/releases/hydra-8.0.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/h/hydra/hydra_8.0.orig.tar.gz"
  sha1 "d1a705985846caf77c291461f391a43457cc76e5"
  revision 1

  head "https://github.com/vanhauser-thc/thc-hydra"

  bottle do
    cellar :any
    sha1 "53c106d9b7e7abf705dd0b7d97fdf568ad71f8a2" => :mavericks
    sha1 "68e042b414cafabc4b0de85cd54c3b84d9eafe96" => :mountain_lion
    sha1 "de61eb606b7ff5b1c9c3b4161101dd12e1b40b76" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on :mysql
  depends_on "libssh" => :optional
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end
end
