class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20150622.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20150622.tar.bz2"
  sha256 "963a9c962ac8f4a53535f779ab7a46336dc6e12234d75dc796248bf9117aef48"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any
    sha256 "d8456028001ea8920372ee9d0898f863b5709e85eb7612e5025d9fa784c87be4" => :yosemite
    sha256 "5cedf1c29de1743221dd097eb994e81ae7b6361ba88c472f27e18162fb0ede78" => :mavericks
    sha256 "467558744f9524789e77ebb7e2409043b1cee9d1e691690301eeb44433912cdd" => :mountain_lion
  end

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable. See the --without-parallel option for 'moreutils'"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
