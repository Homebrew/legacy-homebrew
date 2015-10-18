class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.2.5", :revision => "5d43e94f43f305dd6cc3381463976832b9ef6d98"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "44d23e1c74824b8f2f3f399411f3806f82f8405d6dbaf2fb4f028d8f064280b4" => :el_capitan
    sha256 "ddeb5ad5fb637692cf56527a0b2e695c70875891294702cfe4f822faf89987f6" => :yosemite
    sha256 "0675d030c8b99ce8a19e834fcc02e5ddfb0c0cfe9340c96778a16ee074563279" => :mavericks
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
