class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.3/racket-minimal-6.3-src-builtpkgs.tgz"
  version "6.3"
  sha256 "72d79026e1301ee222089fb555b3eb7290b95f4b7541fec21b4ddb5842fff081"

  bottle do
    revision 1
    sha256 "387b381f886f75682cf7fc96062ccf771ba3cc8d07f468a4cd25d1fec92e392f" => :el_capitan
    sha256 "865df1ab0fa1fae096a156df99b92f91c73746b9720d261ba7dcfe3cb8559662" => :yosemite
    sha256 "cb5cf69488eabefe14f4bbb9c4ffa6028638b9ba7d8bbc13971bda83604a4750" => :mavericks
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
