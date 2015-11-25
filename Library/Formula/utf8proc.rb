class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "http://julialang.org/utf8proc/"
  url "https://github.com/JuliaLang/utf8proc/archive/v1.3.1.tar.gz"
  sha256 "83b60fe21fd8a017b8ad469515873893c8e911a5bef336a427594d398b5688cc"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
