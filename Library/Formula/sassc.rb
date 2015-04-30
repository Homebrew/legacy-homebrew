require "formula"

class Sassc < Formula
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.2.1", :revision => "a88dd098143a1297d68a509f6dd99be25487197a"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "79e88871dbd34e52b0514c389c70d3f357825b0e7f8189ed2e908b3a67884c52" => :yosemite
    sha256 "959cf7e91788324518aebd82e0eee20742b58fd13a87a5d0ffef38c244b5cc96" => :mavericks
    sha256 "0ce34ee21cb1c93321a785a30254880e812c3f3c65ce2a0f0ce2aded0d7ec283" => :mountain_lion
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
