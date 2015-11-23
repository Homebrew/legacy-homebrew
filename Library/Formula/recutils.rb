class Recutils < Formula
  desc "Tools to work with human-editable, plain text data files"
  homepage "https://www.gnu.org/software/recutils/"
  url "http://ftpmirror.gnu.org/recutils/recutils-1.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/recutils/recutils-1.7.tar.gz"
  sha256 "233dc6dedb1916b887de293454da7e36a74bed9ebea364f7e97e74920051bc31"

  bottle do
    cellar :any
    revision 1
    sha256 "b91cd49a977ff93d079ac65a637b6d9681f045368e06a0a1d630ca97e14bd11a" => :yosemite
    sha256 "7e323f2500199e0b1d8fbbd26b33c022c56a9582abdefa401c4629d7152b7f4d" => :mavericks
    sha256 "aec2464c5e26a561b340e9ae5a080366a068936ff2ba4e86e6a4bcf0ed8a95d0" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      a,b,c
      1,2,3
    EOS
    system "#{bin}/csv2rec", "test.csv"
  end
end
