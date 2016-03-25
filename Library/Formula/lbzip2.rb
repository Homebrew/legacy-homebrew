class Lbzip2 < Formula
  desc "Parallel bzip2 utility"
  homepage "https://github.com/kjn/lbzip2"
  url "http://archive.lbzip2.org/lbzip2-2.5.tar.bz2"
  sha256 "eec4ff08376090494fa3710649b73e5412c3687b4b9b758c93f73aa7be27555b"

  bottle do
    cellar :any_skip_relocation
    sha256 "91c1fb0593205365ff4ada30a34fe7f3afcb1c4e684a3bf239e9168d9fdfc4f7" => :el_capitan
    sha256 "983c8fe1c23dbfdb73d9e7320e776521c4998169a2d17cd1c6f3035674d8a147" => :yosemite
    sha256 "7e521c70fadae71ad2e7807cc844183c05751e4a2433d9f1210069fb2a34333e" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    touch "fish"
    system "#{bin}/lbzip2", "fish"
    system "#{bin}/lbunzip2", "fish.bz2"
  end
end
