class Re2c < Formula
  homepage "http://re2c.org"
  url "https://downloads.sourceforge.net/project/re2c/re2c/0.14.2/re2c-0.14.2.tar.gz"
  sha256 "a702eb63977af4715555edb41eba3b47bbfdcdb44b566d146869a7db022f1c30"

  bottle do
    cellar :any
    sha256 "22b82ae03ac1c69932ca72260b479469a30ed24bdee7536d797dd95e2b369da4" => :yosemite
    sha256 "8c6ea2d5466a87211b33d8be156ffeb97aa9cfa1c9a5fa9c9fa21b8a7e436629" => :mavericks
    sha256 "1a167fbc6d08ef5a9ddf483d0661036529865c7dc594395d321428e3c1185a06" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    EOS
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
