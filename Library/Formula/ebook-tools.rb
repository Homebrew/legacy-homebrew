require "formula"

class EbookTools < Formula
  homepage "http://sourceforge.net/projects/ebook-tools"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha1 "1f10bef62c9125cf804366134e486a58308f07ff"

  depends_on "libzip"
  depends_on "cmake" => :build

  def install
    libzip_include = Formula["libzip"].lib
    libzip_cmake_arg = "-DLIBZIP_INCLUDE_DIR=#{libzip_include}/libzip/include"
    system "cmake", ".", libzip_cmake_arg, *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/einfo", "-help"
  end
end
