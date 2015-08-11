class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.2.1/racket-minimal-6.2.1-src-builtpkgs.tgz"
  version "6.2.1"
  sha256 "47eceb5f23ab66a939650fa44dd89ffcb17a6227f58c6bc80e90aa8999c86b36"

  bottle do
    sha256 "80af5793e7bfa204023d9151e7cf6094ab9be9fa593287b0d6f0b66d9667baae" => :yosemite
    sha256 "a416f438831e81834a24a378bdd9f65fc3c3876bf67e2db753b88c08a359da20" => :mavericks
    sha256 "066229247a0787b7a05f610713da183b97253a44a0f40fc1cd4e15e6d3108511" => :mountain_lion
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
