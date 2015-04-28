class Jed < Formula
  homepage "http://www.jedsoft.org/jed/"
  url "http://www.jedsoft.org/releases/jed/jed-0.99-19.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jed/jed_0.99.19.orig.tar.gz"
  sha256 "5eed5fede7a95f18b33b7b32cb71be9d509c6babc1483dd5c58b1a169f2bdf52"

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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
