class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "http://xdelta.org"
  url "https://github.com/jmacd/xdelta-devel/releases/download/v3.0.10/xdelta3-3.0.10.tar.gz"
  sha256 "e22577af8515f91b3d766dffa2a97740558267792a458997828f039b79abc107"

  bottle do
    cellar :any
    sha256 "4f7dec576387e2987edd57be6e1e9df740ee2c53207f61b775904f36936dee8f" => :yosemite
    sha256 "715d5c3a585879d25788ab619bddaaca1c7f7ff45b254277e5becb33c97f4857" => :mavericks
    sha256 "7adf5ae7a00473f5c12f8c377da22ad3f98a0ef4e179c6c0b64b03de075cc756" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
