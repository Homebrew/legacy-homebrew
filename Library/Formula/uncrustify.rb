class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "http://uncrustify.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.61/uncrustify-0.61.tar.gz"
  sha256 "1df0e5a2716e256f0a4993db12f23d10195b3030326fdf2e07f8e6421e172df9"

  head "https://github.com/bengardner/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d6c1d92a813e4a27140bf85e5f859749573b715c73c77f1efb381f95b304f47" => :el_capitan
    sha256 "dbe3a584778aa7139d560abe1400417f7fa4e83e363a414d4f9d9990a066ed73" => :yosemite
    sha256 "2d6b33c9397482a3b5013563262ea62737dcc4d2a9a77416ffd646e3842f2e15" => :mavericks
    sha256 "04548fc7f44bd61aadad55e3dc8a69634783e349ca4156d605953779aecaf8b8" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"t.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<-EOS.undent
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{share}/uncrustify/defaults.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end
