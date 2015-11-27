class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.3.2", :revision => "7efa9c452f4f2a814fbe74448ebdc2e703e67a4a"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "afcce4ded5d004f16ac4ae183299db22ff63ca08a3dc0739f1de2aa88a49fe56" => :el_capitan
    sha256 "dcc04e5f93e260a94d60449e815dfb6ca1fbd84964b7d40d038a3d4fa1e362b8" => :yosemite
    sha256 "b194d61b61895ba2082c4ece22ae51abd1a2ab9c16449acc7f5b6f7a77ee17a6" => :mavericks
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
