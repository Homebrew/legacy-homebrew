class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20150922.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20150922.tar.bz2"
  sha256 "f2b485fabdca6492d892c57f50d112a7693f8dc088f74787c98eeb2aa11cee17"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90c9e106fcfa69afa562b316d17d5086df0c73d47c36029486376d1ce126f5ba" => :el_capitan
    sha256 "4472b8e99d1f130f644d6db0f947c110af4a31445ec8911d8234b3dc8afb543c" => :yosemite
    sha256 "809bb9988650900a45e44175866912a43186da03048b0be867fa8fb970b6a4d9" => :mavericks
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
