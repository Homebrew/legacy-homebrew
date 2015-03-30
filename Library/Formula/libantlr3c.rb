class Libantlr3c < Formula
  homepage "http://www.antlr3.org"
  url "http://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz"
  sha256 "ca914a97f1a2d2f2c8e1fca12d3df65310ff0286d35c48b7ae5f11dcc8b2eb52"
  revision 1

  option "without-exceptions", "Compile without support for exception handling"

  bottle do
    cellar :any
    revision 1
    sha1 "5340de248798194c46c5112c73a1ba409912059d" => :yosemite
    sha1 "044b66cb95b396080f1729cc04f9a960f08e6ea5" => :mavericks
    sha1 "b02f52cf3c696b52974e90532cf66964e61c750d" => :mountain_lion
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-antlrdebug",
            "--prefix=#{prefix}"]
    args << "--enable-64bit" if MacOS.prefer_64_bit?
    system "./configure", *args
    if build.with? "exceptions"
      inreplace "Makefile" do |s|
        cflags = s.get_make_var "CFLAGS"
        cflags = cflags << " -fexceptions"
        s.change_make_var! "CFLAGS", cflags
      end
    end
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
      #include <antlr3.h>
      int main() {
        if (0) {
          antlr3GenericSetupStream(NULL);
        }
        return 0;
      }
    EOS
    system ENV.cc, "hello.c", "-lantlr3c", "-o", "hello", "-O0"
    system testpath/"hello"
  end
end
