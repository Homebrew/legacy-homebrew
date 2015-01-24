class Mdk < Formula
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "ftpmirror.gnu.org/gnu/mdk/v1.2.8/mdk-1.2.8.tar.gz"
  sha1 "43bd40a48f88b3458c3bb6ccfd62d254b85c5fb8"

  depends_on "gtk+3"
  depends_on "glib"
  depends_on "libglade"
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
    helloworld = '
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
'

    expected = 'Program loaded. Start address: 1000
Running ...
MIXAL HELLO WORLD                                                     
... done
'
    (testpath/"hello.mixal").write(helloworld)
    system "echo", (testpath)
    system "#{bin}/mixasm",  "hello"
    output = `#{bin}/mixvm -r hello`
    #system "sleep", "100000"
    assert_equal expected, output
  end
end
