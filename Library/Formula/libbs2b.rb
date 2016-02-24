class Libbs2b < Formula
  desc "Bauer stereophonic-to-binaural DSP"
  homepage "http://bs2b.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz"
  sha256 "6aaafd81aae3898ee40148dd1349aab348db9bfae9767d0e66e0b07ddd4b2528"

  bottle do
    cellar :any
    revision 1
    sha256 "62a45fde4ae7db34b1c14212d2c0ec5c603fdc403dc1df2b629972789dc7489e" => :yosemite
    sha256 "7cf43c31d5aee33a241af345c4b8a05fc73f48afc8b9f37d5ad9c4fa22d6920e" => :mavericks
    sha256 "d97d172800ed96916fa256625cc08320286cd0f0609c25ecf310535fc9266330" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-static",
                          "--enable-shared"
    system "make", "install"
  end
end
