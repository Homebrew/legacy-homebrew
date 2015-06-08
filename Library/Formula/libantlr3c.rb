class Libantlr3c < Formula
  desc "ANTLRv3 parsing library for C"
  homepage "http://www.antlr3.org"
  url "http://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz"
  sha256 "ca914a97f1a2d2f2c8e1fca12d3df65310ff0286d35c48b7ae5f11dcc8b2eb52"
  revision 1

  option "without-exceptions", "Compile without support for exception handling"

  bottle do
    cellar :any
    sha256 "8026d876b20980138c076cb4008f358deb858204b6399c436cf45e93594274e7" => :yosemite
    sha256 "010c3866a3c183b10dec76f845ce826a26a5a384074f8c56f41abeb9e4aa6e77" => :mavericks
    sha256 "e734361de9f3f5d81b0a0224cfcb561806fed5b1d5dbeeb86bd2131754aa993d" => :mountain_lion
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
