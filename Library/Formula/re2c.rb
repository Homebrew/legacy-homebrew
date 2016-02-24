class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://downloads.sourceforge.net/project/re2c/0.15.3/re2c-0.15.3.tar.gz"
  sha256 "f9d2a96c60a8c60d9c6c70e10590cbceaf0776d3115e7b3b35c7d7240cc1613b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a548a61d9336f1496572cdeb0e878bdbafb5b37c15e7228a2484964fff9337c" => :el_capitan
    sha256 "04878ac4a2996470f040650a7c5f5890df785c97f392c82193c0250d5e9efea9" => :yosemite
    sha256 "0a20c12bf55cf36c11a3dc65a9a7dafd3028af79e560ab674556f0ee7e2c37df" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
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
