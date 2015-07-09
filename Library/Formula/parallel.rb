class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20150622.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20150622.tar.bz2"
  sha256 "963a9c962ac8f4a53535f779ab7a46336dc6e12234d75dc796248bf9117aef48"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any
    sha256 "6f9215219c74156007b216b8fd68115ff4570fb598f1cbeee33ddb717ef585f4" => :yosemite
    sha256 "1450c6fba3aa0f6f2a337a201d07f3d2b3bb5c83c50fe8f10228eb7e06e950e3" => :mavericks
    sha256 "0dfdf16c6ee7dcbaf1c0c56f269cf42184826b4bae627136aa1f4c552d52d47f" => :mountain_lion
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
