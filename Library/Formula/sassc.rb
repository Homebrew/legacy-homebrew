require "formula"

class Sassc < Formula
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc/archive/3.0.2.tar.gz"
  sha1 "4666a8452005613afe4129a8e0cb4dd9e54b2868"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha1 "65fb58f5c6fe34eeff1ea207b8757bcec2a3e1c9" => :yosemite
    sha1 "262ebee2c5fddcb2e29789ab8114c83abf3aeded" => :mavericks
    sha1 "740702bd6479be486197055af380bc941ccb312e" => :mountain_lion
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
