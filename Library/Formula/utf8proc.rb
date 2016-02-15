class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "http://julialang.org/utf8proc/"
  url "https://github.com/JuliaLang/utf8proc/archive/v1.3.1.tar.gz"
  sha256 "83b60fe21fd8a017b8ad469515873893c8e911a5bef336a427594d398b5688cc"

  bottle do
    cellar :any
    sha256 "ebecca82cd8d532a928cf5137e8589fdf968cff9ad723fae6d6fbfdd76148709" => :el_capitan
    sha256 "8d117faedfa60b37e7b25598aed8b3d9d4dd048ecbb474e42c1014b20ec141c2" => :yosemite
    sha256 "45176943620b894aa86b50a2774e1241d0a7ebd85d0edeb1e56665c8240d9c31" => :mavericks
  end

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
