require "formula"

class Sassc < Formula
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.2.1", :revision => "a88dd098143a1297d68a509f6dd99be25487197a"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha1 "744cd165da007750644e6eb3cfb1a7b76d94c7a2" => :yosemite
    sha1 "d6d38f5d139073162943d1a5828c1b8b38e998be" => :mavericks
    sha1 "26c429c4b643c8cf8602e2534f44473e18859ab5" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libsass"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"input.scss").write <<-EOS.undent
      div {
        img {
          border: 0px;
        }
      }
    EOS

   assert_equal "div img{border:0px}",
   shell_output("#{bin}/sassc --style compressed input.scss").strip
  end
end
