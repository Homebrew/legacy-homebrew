require "formula"

class PltRacket < Formula
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.0.1/racket-minimal-6.0.1-src-builtpkgs.tgz"
  sha1 "41bc76a8e0ffb5d2b108d52faeca1d6ed71a4318"
  version "6.0.1"

  bottle do
    sha1 "8fe12b0e00d00380efb7970ec02b7555d8884224" => :mavericks
    sha1 "10a540120f21bcb9f52a65f54a03c43a27ea8232" => :mountain_lion
    sha1 "1311bbd0ed30ed4025057d4f7639a69fdeaf10ec" => :lion
  end

  def install
    cd 'src' do
      args = ["--disable-debug", "--disable-dependency-tracking",
              "--enable-macprefix",
              "--prefix=#{prefix}",
              "--man=#{man}"]

      args << "--disable-mac64" if not MacOS.prefer_64_bit?

      system "./configure", *args
      system "make"
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    This is a minimal Racket distribution.
    If you want to use the DrRacket IDE, we recommend that you use
    the PLT-provided packages from http://racket-lang.org/download/.
    EOS
  end

  test do
    output = `'#{bin}/racket' -e '(displayln "Hello Homebrew")'`
    assert $?.success?
    assert_match /Hello Homebrew/, output
  end
end
