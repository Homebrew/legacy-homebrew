class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.3/racket-minimal-6.3-src-builtpkgs.tgz"
  version "6.3"
  sha256 "72d79026e1301ee222089fb555b3eb7290b95f4b7541fec21b4ddb5842fff081"

  bottle do
    sha256 "a37d51fb235adfe4b796335e56eb6b826b9967ed6a75c996360997865cdabd49" => :el_capitan
    sha256 "0ab11d912b82ab21b53990b94c8e9d55c28d3a5d6c4c58335f29e78aa937c7c5" => :yosemite
    sha256 "474e72aee9d5e4a3b122caac9fe5429da912050bc9353f8c3a8687c4ff232b0d" => :mavericks
  end

  def install
    cd "src" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --enable-macprefix
        --prefix=#{prefix}
        --man=#{man}
        --sysconfdir=#{etc}
      ]

      args << "--disable-mac64" unless MacOS.prefer_64_bit?

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    This is a minimal Racket distribution.
    If you want to use the DrRacket IDE, we recommend that you use
    the PLT-provided packages from http://racket-lang.org/download/.
    EOS
  end

  test do
    output = shell_output("#{bin}/racket -e '(displayln \"Hello Homebrew\")'")
    assert_match /Hello Homebrew/, output
  end
end
