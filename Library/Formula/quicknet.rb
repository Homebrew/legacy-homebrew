class Quicknet < Formula
  desc "Software suite for multi-layer perceptrons, designed for ASR."
  homepage "http://www1.icsi.berkeley.edu/Speech/qn.html"
  url "ftp://ftp.icsi.berkeley.edu/pub/real/davidj/quicknet.tar.gz"
  version "3.33"
  sha256 "035003767e1d7580ae30bdf3c4ff839a9b380e239d4b2ecde85df55d94f9a145"

  patch do
    # patch Makefile.in to make mandir configurable, so we can adjust it to the homebrew standards using configure later
    # review patch here: https://gist.github.com/Marvin182/41492c9d1992052fa35d
    url "https://gist.githubusercontent.com/Marvin182/41492c9d1992052fa35d/raw/7e8f3e4102f7cbb2408cf7bf07b2f01f6f1edcb3/patch_quicknet_mandir.diff"
    sha256 "ebe0f7c57b549fcdef5a2945f50e2dc1145a966113ec6138d8f7ab139ec0b459"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert File.exist? "#{bin}/qncopy"
    assert File.exist? "#{bin}/qncopywts"
    assert File.exist? "#{bin}/qndo"
    assert File.exist? "#{bin}/qnmultifwd"
    assert File.exist? "#{bin}/qnmultitrn"
    assert File.exist? "#{bin}/qnnorm"
    assert File.exist? "#{bin}/qnsfwd"
    assert File.exist? "#{lib}/libquicknet3.dylib"
  end
end
