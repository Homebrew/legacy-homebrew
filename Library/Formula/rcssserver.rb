require "formula"

class Rcssserver < Formula
  homepage "http://sserver.sourceforge.net/"
  url "https://downloads.sourceforge.net/sserver/rcssserver/15.2.2/rcssserver-15.2.2.tar.gz"
  sha1 "43012eb5301716e457e93ec42c0c00727e600c84"

  depends_on "flex" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rcssserver help | head -1 | grep 'rcssserver-#{version}'"
  end
end
