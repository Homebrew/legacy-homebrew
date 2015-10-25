class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.2.1/racket-minimal-6.2.1-src-builtpkgs.tgz"
  version "6.2.1"
  sha256 "47eceb5f23ab66a939650fa44dd89ffcb17a6227f58c6bc80e90aa8999c86b36"

  bottle do
    revision 1
    sha256 "387b381f886f75682cf7fc96062ccf771ba3cc8d07f468a4cd25d1fec92e392f" => :el_capitan
    sha256 "865df1ab0fa1fae096a156df99b92f91c73746b9720d261ba7dcfe3cb8559662" => :yosemite
    sha256 "cb5cf69488eabefe14f4bbb9c4ffa6028638b9ba7d8bbc13971bda83604a4750" => :mavericks
  end

  # Upstream patch to resolve 10.11 build errors to handle `availability` declarations.
  # Remove on next release.
  patch :p2 do
    url "https://github.com/racket/racket/commit/1ddaad8d58.diff"
    sha256 "136993d40613a0f657c73b1b3694ab79ef74e411ee0698ca70fd94800bb9e7d1"
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
