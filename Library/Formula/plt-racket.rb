class PltRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.2/racket-minimal-6.2-src-builtpkgs.tgz"
  sha256 "ff5d49729e79c109f5d1ea9a6faef9f5fb13861a6e19ca2e095e34a77ad8f03d"
  version "6.2"

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
    output = `'#{bin}/racket' -e '(displayln "Hello Homebrew")'`
    assert $?.success?
    assert_match /Hello Homebrew/, output
  end
end
