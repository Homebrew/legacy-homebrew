class EbookTools < Formula
  desc "Access and convert several ebook formats"
  homepage "https://sourceforge.net/projects/ebook-tools/"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha256 "cbc35996e911144fa62925366ad6a6212d6af2588f1e39075954973bbee627ae"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "5e8c1713c5d418a039181ca164e5a9f04691f430c2262a778627457e928104b9" => :el_capitan
    sha256 "66d084a7aed69b423d60ab2d193c73751a68a489c717178db36662f50ad9cdb3" => :yosemite
    sha256 "09c68b7cea454f3181f5df5eae0b5b9ece75e697bcc876354de8de0fc6aa9e9a" => :mavericks
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
