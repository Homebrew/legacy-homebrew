class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "http://www.ling.helsinki.fi/kieliteknologia/tutkimus/hfst/"
  url "https://downloads.sourceforge.net/project/hfst/hfst/archive/hfstospell-0.3.0.tar.gz"
  sha256 "07b5b368882cac2399edb1bb6e2dd91450b56f732c25413a19fcfe194342d70c"

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
