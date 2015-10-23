class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.2.1/racket-minimal-6.2.1-src-builtpkgs.tgz"
  version "6.2.1"
  sha256 "47eceb5f23ab66a939650fa44dd89ffcb17a6227f58c6bc80e90aa8999c86b36"

  bottle do
    sha256 "4d985a857e7556b1665e0f2d8f4c7f9667e34794cd047788d5b2af6fa5e98a13" => :yosemite
    sha256 "8aab33739c8818a3408f478268d310a2c6f0734ac89b9e9bd5fe1ad10ecf1eb2" => :mavericks
    sha256 "d10ec37ab262c32ce23cbc253cd52a3b381e285a848b073048a5f593a9446b13" => :mountain_lion
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
