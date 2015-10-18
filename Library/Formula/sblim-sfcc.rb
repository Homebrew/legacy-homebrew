class SblimSfcc < Formula
  desc "Project to enhance the manageability of GNU/Linux system"
  homepage "https://sourceforge.net/projects/sblim/"
  url "https://downloads.sourceforge.net/project/sblim/sblim-sfcc/sblim-sfcc-2.2.8.tar.bz2"
  sha256 "1b8f187583bc6c6b0a63aae0165ca37892a2a3bd4bb0682cd76b56268b42c3d6"

  bottle do
    sha1 "3ee7ffa2d2daa39ae2488d9408ad8b8dafb2592f" => :yosemite
    sha1 "8cfe583a363961d6fa360b5eba800d045fb4a263" => :mavericks
    sha1 "57c0de85854ce44df4423729adb2dc433000d707" => :mountain_lion
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
