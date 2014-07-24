require "formula"

class PltRacket < Formula
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.0.1/racket-minimal-6.0.1-src-builtpkgs.tgz"
  sha1 "41bc76a8e0ffb5d2b108d52faeca1d6ed71a4318"
  version "6.0.1"

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
