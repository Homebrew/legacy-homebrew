class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "http://uncrustify.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.61/uncrustify-0.61.tar.gz"
  sha256 "1df0e5a2716e256f0a4993db12f23d10195b3030326fdf2e07f8e6421e172df9"

  head "https://github.com/bengardner/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d6c1d92a813e4a27140bf85e5f859749573b715c73c77f1efb381f95b304f47" => :el_capitan
    sha1 "82e6f950648e0a04411e84a563ff96a50b2b8efc" => :yosemite
    sha1 "9040d701020412937138be6e1521d136d44961b3" => :mavericks
    sha1 "999421447b999f73f5850e3275e5f47775e0cc27" => :mountain_lion
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
