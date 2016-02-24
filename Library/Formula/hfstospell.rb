class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "http://www.ling.helsinki.fi/kieliteknologia/tutkimus/hfst/"
  url "https://downloads.sourceforge.net/project/hfst/hfst/archive/hfstospell-0.3.0.tar.gz"
  sha256 "07b5b368882cac2399edb1bb6e2dd91450b56f732c25413a19fcfe194342d70c"

  bottle do
    cellar :any
    sha256 "9417cec27aed563db269d83402af875161724b10297ab78c4e69e4811c60866a" => :el_capitan
    sha256 "4dcc41f94c027f765b2d8e9e3859a72797d1d2f2e0e59b8f33ef47831dbcefea" => :yosemite
    sha256 "87cfbe776c920c653c7baf52d8492e6f2fc19a3c440026d09f0a8c05e3c26a87" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
