class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20150522.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20150522.tar.bz2"
  sha256 "4c4a199740189a4a220a10da29fdb33a0b71abef1f253eeb89a28da6f264f306"
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
end
