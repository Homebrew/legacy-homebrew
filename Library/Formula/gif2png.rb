class Gif2png < Formula
  desc "Convert GIFs to PNGs."
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-2.5.11.tar.gz"
  sha256 "40483169d2de06f632ada1de780c36f63325844ec62892b1652193f77fc508f7"

  bottle do
    cellar :any
    sha256 "6d36f52b4d4aff69ea5a4599f1e8830a7cf9487e39d169d11155f915953ae51b" => :el_capitan
    sha256 "51e3d439570ad14778998aa06367be48a60a2d9b278ae865fa502f60307b501f" => :yosemite
    sha256 "fefb1fb3cea89f455dd7b37ead607bdeeaf0c3a3c7c342e053f2f02bac323960" => :mavericks
  end

  depends_on "libpng"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end
