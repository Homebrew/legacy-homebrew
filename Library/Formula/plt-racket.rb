class PltRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.2/racket-minimal-6.2-src-builtpkgs.tgz"
  sha256 "ff5d49729e79c109f5d1ea9a6faef9f5fb13861a6e19ca2e095e34a77ad8f03d"
  version "6.2"

  bottle do
    sha256 "e8817da253500c3b51bf818059cfb4174252a939433b1755f965fd06f381a7c2" => :yosemite
    sha256 "e775405462072cf43df41bc70b2faad9d065f4bb095bf21acd2fbba64be78777" => :mavericks
    sha256 "165a42022c0543bfcc05954f62315b419efdc789e29a5c6e6aec14af52ee85b2" => :mountain_lion
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
