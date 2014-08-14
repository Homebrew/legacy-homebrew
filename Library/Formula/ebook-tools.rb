require "formula"

class EbookTools < Formula
  homepage "http://sourceforge.net/projects/ebook-tools"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha1 "1f10bef62c9125cf804366134e486a58308f07ff"

  depends_on "libzip"
  depends_on "cmake" => :build

  def install
    system "cmake", ".",
                    "-DLIBZIP_INCLUDE_DIR=#{Formula["libzip"].lib}/libzip/include",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/einfo", "-help"
  end
end
