require "formula"

class EbookTools < Formula
  homepage "http://sourceforge.net/projects/ebook-tools"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha1 "1f10bef62c9125cf804366134e486a58308f07ff"

  bottle do
    cellar :any
    sha1 "5bccca25c0dc3fd0034de38a034f7bb632c7f370" => :yosemite
    sha1 "aca4f5f51bcf5254ada57236d204cdcfabb712a9" => :mavericks
    sha1 "7df61c7aa09c89a59c3ed7fc3fbd302ee8768e81" => :mountain_lion
  end

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
