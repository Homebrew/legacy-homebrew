class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "http://ftpmirror.gnu.org/mdk/v1.2.8/mdk-1.2.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mdk/v1.2.8/mdk-1.2.8.tar.gz"
  sha256 "7bff1e10b829c6e1f3c278bfecbe82f0f658753ce80ea58b6f71c05f9490b0db"
  revision 1

  bottle do
    revision 1
    sha256 "5b24eaf48d048cd8d482ec4b28dc093e5e75fe4e3430934d8930b64d003d7b5c" => :yosemite
    sha256 "73dee962b53150de146a017161004995a341a7239554b46a5f895c31aea80755" => :mavericks
    sha256 "76631db9d820f00fa4f807c9316c08b20a54151827f5b40d7b49a5608dbba547" => :mountain_lion
  end

  depends_on "gtk+"
  depends_on "libglade"
  depends_on "glib"
  depends_on "flex"
  depends_on "guile"
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.mixal").write <<-EOS.undent
      *                                                        (1)
      * hello.mixal: say "hello world" in MIXAL                (2)
      *                                                        (3)
      * label ins    operand     comment                       (4)
      TERM    EQU    19          the MIX console device number (5)
              ORIG   1000        start address                 (6)
      START   OUT    MSG(TERM)   output data at address MSG    (7)
              HLT                halt execution                (8)
      MSG     ALF    "MIXAL"                                   (9)
              ALF    " HELL"                                   (10)
              ALF    "O WOR"                                   (11)
              ALF    "LD"                                      (12)
              END    START       end of the program            (13)
    EOS
    system "#{bin}/mixasm",  "hello"
    output = `#{bin}/mixvm -r hello`

    expected =  <<-EOS.undent
      Program loaded. Start address: 1000
      Running ...
      MIXAL HELLO WORLDXXX
      ... done
    EOS
    expected = expected.gsub("XXX", " " *53)

    assert_equal expected, output
  end
end
