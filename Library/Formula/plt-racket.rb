require "formula"

class PltRacket < Formula
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.1.1/racket-minimal-6.1.1-src-builtpkgs.tgz"
  sha1 "8800c89a981f7b86808c7d9f2173c7f2a47147bc"
  version "6.1.1"

  bottle do
    sha1 "ce1209d975593554d7973bb30d06f4897672c3b5" => :yosemite
    sha1 "04953a38b638ed718063f123da83a3eed9f3bb99" => :mavericks
    sha1 "79bf69d88c0479cf180f56e9d67d48833ce0a34a" => :mountain_lion
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
