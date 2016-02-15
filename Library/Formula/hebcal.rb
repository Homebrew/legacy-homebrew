class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.0.2.tar.gz"
  sha256 "03d717a59d9518c2330ecbadb4f6b6870e8bad07f970ca7d4fd40d085637e259"

  bottle do
    cellar :any_skip_relocation
    sha256 "fee61343b38eea36591004611ec9ca0d73e539d1884e9aab5413ed6faf4002f4" => :el_capitan
    sha256 "78d94aca4414e2710e2339e86ae2968150de60c615962dea3b3efc510fb5b84e" => :yosemite
    sha256 "1ff24cc5992fd985bc2915625613931769d531723c268601a820421a5aaa651b" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
