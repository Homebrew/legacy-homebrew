class SblimSfcc < Formula
  desc "Project to enhance the manageability of GNU/Linux system"
  homepage "https://sourceforge.net/projects/sblim/"
  url "https://downloads.sourceforge.net/project/sblim/sblim-sfcc/sblim-sfcc-2.2.8.tar.bz2"
  sha256 "1b8f187583bc6c6b0a63aae0165ca37892a2a3bd4bb0682cd76b56268b42c3d6"

  bottle do
    sha256 "6d2ececce1f13c1b74ee7497f6a2319408fcf14e0c48660056fafc3216f9b23b" => :yosemite
    sha256 "0a121e50395af8c870c05108a67bcc9019c754fe0ca7eb5bd5efd2638fcac416" => :mavericks
    sha256 "c80645daeb763a5aaa16fa60ab02b006e26f698d5c0fce6464e07c4f59fa1a75" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  # based on the test at #https://github.com/Homebrew/homebrew/blob/master/Library/Formula/tinyxml.rb
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cimc/cimc.h>
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lcimcClient", "-o", "test"
    system "./test"
  end
end
