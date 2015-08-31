class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "http://xdelta.org"
  url "https://github.com/jmacd/xdelta-devel/releases/download/v3.0.10/xdelta3-3.0.10.tar.gz"
  sha256 "e22577af8515f91b3d766dffa2a97740558267792a458997828f039b79abc107"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
