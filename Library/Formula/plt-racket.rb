require "formula"

class PltRacket < Formula
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.1/racket-minimal-6.1-src-builtpkgs.tgz"
  sha1 "988cc297eb35e26585cceac67ae00ebfd47174e2"
  version "6.1"

  bottle do
    sha1 "91605ef5aca76449ad465669f21b940fa5ffd8fd" => :mavericks
    sha1 "9de25cf2475b3aba5a58a721325fc9d1a9656f12" => :mountain_lion
    sha1 "a0862a96129f518d28625bf55fddb89b7fcb06f5" => :lion
  end

  def install
    cd "src" do
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
