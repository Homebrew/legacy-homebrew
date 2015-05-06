class Re2c < Formula
  homepage "http://re2c.org"
  url "https://downloads.sourceforge.net/project/re2c/re2c/0.14.2/re2c-0.14.2.tar.gz"
  sha256 "a702eb63977af4715555edb41eba3b47bbfdcdb44b566d146869a7db022f1c30"

  bottle do
    cellar :any
    sha256 "968ea6c2d830f93ea6e28012e32329e05a848c5cbf77c4012b861275efeaf4b7" => :yosemite
    sha256 "50e2a4b23a056cc242403b446f231268c8836c7bc2586d543c2a5af0faac4d02" => :mavericks
    sha256 "1aae924b080f3d72da21a445681f125c03ae526617bec1e3ebb59c2eacbc1ebe" => :mountain_lion
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
