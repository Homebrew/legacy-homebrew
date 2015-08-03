class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.2.4", :revision => "a88dd098143a1297d68a509f6dd99be25487197a"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "1ad01ed7c28efd12f067f2cc6a743ec291218231462f17419b32be0d09538901" => :yosemite
    sha256 "ce98149a0cf434fda2ce3e9803f92a77c4581df9ca7b9f8f13478b56670c956c" => :mavericks
    sha256 "16150a5116dd01b150f1b48696e0dfc256cb38d5b4f5aff9f4edb18bd5d9c54c" => :mountain_lion
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
