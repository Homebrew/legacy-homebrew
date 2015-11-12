class EbookTools < Formula
  desc "Access and convert several ebook formats"
  homepage "http://sourceforge.net/projects/ebook-tools"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha256 "cbc35996e911144fa62925366ad6a6212d6af2588f1e39075954973bbee627ae"
  revision 1

  bottle do
    cellar :any
    sha256 "2f88f3ae90a7ba51931938bfb72bc5ab15d3f25cf288f8842325cb15fa7eb391" => :el_capitan
    sha256 "d7a3d58d4626049940515bde5a33ef9dfce2e4adcfa34237fd0f66e1e9e260cf" => :yosemite
    sha256 "9bf576c168575ccbf8b9c3abce0374ace176669ae0f84d33d2ff10f81d1a2cdb" => :mavericks
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
