class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://downloads.sourceforge.net/project/re2c/re2c/0.14.3/re2c-0.14.3.tar.gz"
  sha256 "1c6806df599f3aef0804b576cfdf64bdba5ad590626dfca2d44e473460917e84"

  bottle do
    cellar :any_skip_relocation
    sha256 "63da94c4a7566d3c95c6e85ab3dcfc57b8e9178faa6c8e6e8e605f01c7a5a354" => :el_capitan
    sha256 "7040c6d1946125f13649a16b21ac9d44afd3c0539dfc2ce97e376c436b768141" => :yosemite
    sha256 "06528f7fb154253ba75560e7ea77845fda54e2cbb9257244c4ea63afd40d6fe4" => :mavericks
    sha256 "1cafc788466d50c7d1f68719b0fd62b9f2599a5909c4c280043d91e17d4aa183" => :mountain_lion
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
