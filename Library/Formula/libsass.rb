class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git", :tag => "3.3.1", :revision => "42e22fbadfcdc8ac3b983890518dfa0ebff3c229"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha256 "aa42c22560ddbd035621ff0fbb1917dda2553f70cace3fff1c288bcb66b5fd45" => :el_capitan
    sha256 "c89c308461247e28f4f3fc28b1f382a084dbd3e0e676b70795795584de8b1af7" => :yosemite
    sha256 "a0ed9cd621f571ec0eb18257caf6fec86d71167b76940f6f117cc759ed03f3aa" => :mavericks
    sha256 "0fc382b2657adf1c1ed6196846ceff50824343d9f7c9a9ad6d2c32eab4346981" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  needs :cxx11

  def install
    ENV.cxx11
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
    shell_output("#{bin}/sassc/bin/sassc --style compressed input.scss").strip
  end
end
