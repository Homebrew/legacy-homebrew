class Mkcue < Formula
  desc "Generate a CUE sheet from a CD"
  homepage "https://packages.debian.org/source/stable/mkcue"
  url "https://mirrors.kernel.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  version "1"
  sha256 "2aaf57da4d0f2e24329d5e952e90ec182d4aa82e4b2e025283e42370f9494867"

  bottle do
    cellar :any
    revision 1
    sha256 "7c8965e6faf42fade5b1429949245c585cd2c63484922bcbf5f2c5ba856ea3ef" => :yosemite
    sha256 "e61b43ae2764c4ffc7779c494393bf403e74d68a0405f8cf1edcc19839c9aced" => :mavericks
    sha256 "73c56acd7623139c54250d8105687d143cf228dca17576005842107cd08c43a7" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    bin.mkpath
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system "#{bin}/mkcue", "test"
  end
end
