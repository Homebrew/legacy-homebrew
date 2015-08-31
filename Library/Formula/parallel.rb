class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20150822.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20150822.tar.bz2"
  sha256 "ad9007530d87687160fd8def58721acdac244c151b6c007f35068909bb5c47c6"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any
    sha256 "b004dfa3ab1e61c00d79cd493c96e8a1ad3d036c7864802c6b3294a23dc05313" => :yosemite
    sha256 "994fc816ae29f32393a5559ad0581db5b245bf0c7cea72f1923b9537ba85440e" => :mavericks
    sha256 "4774977f539c70987684087ebfe652434adb1212f4e120336ed022afac081eae" => :mountain_lion
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
