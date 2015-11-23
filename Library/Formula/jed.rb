class Jed < Formula
  desc "JED is a powerful editor for programmers"
  homepage "http://www.jedsoft.org/jed/"
  url "http://www.jedsoft.org/releases/jed/jed-0.99-19.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jed/jed_0.99.19.orig.tar.gz"
  sha256 "5eed5fede7a95f18b33b7b32cb71be9d509c6babc1483dd5c58b1a169f2bdf52"

  bottle do
    sha256 "3b316c792feabf9622a70a8ccdf2d2e985e7f991dbcd49a104b2ee6b8ea078cb" => :yosemite
    sha256 "f0e02951e534d96baad147970e51b2f5c09155ad0e51114cfc72b3f49301dff3" => :mavericks
    sha256 "595aff2e43b8ec8c31626831dcab83ffe4ffc129ea85efa61bc2e35877137a29" => :mountain_lion
  end

  head do
    url "git://git.jedsoft.org/git/jed.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "s-lang"
  depends_on :x11 => :optional

  def install
    if build.head?
      cd "autoconf" do
        system "make"
      end
    end
    system "./configure", "--prefix=#{prefix}",
                          "--with-slang=#{Formula["s-lang"].opt_prefix}"
    system "make"
    system "make", "xjed" if build.with? "x11"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sl").write "flush (\"Hello, world!\");"
    assert_equal "Hello, world!",
                 shell_output("#{bin}/jed -script test.sl").chomp
  end
end
