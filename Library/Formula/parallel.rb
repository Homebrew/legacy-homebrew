class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20150822.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20150822.tar.bz2"
  sha256 "ad9007530d87687160fd8def58721acdac244c151b6c007f35068909bb5c47c6"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "420e4f174531d23a4ee759bd553966dac737b3d7f013eb172734c6315739df7b" => :el_capitan
    sha256 "c6dd1794c15b00c77e9a5556bfe0edac97d422f408d34cbb00992e69ce2614a2" => :yosemite
    sha256 "5eb6f10c81f5fb608d476ad075fd9c922f6144be1bfdc39c1f41303e4dacd8df" => :mavericks
    sha256 "8ce7a360d18600da0dd69dd87ecadc82282dfb7b876ab76817ef3b25e06f2520" => :mountain_lion
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
