class Fastjar < Formula
  desc "Implementation of Sun's jar tool"
  homepage "http://sourceforge.net/projects/fastjar/"
  url "https://downloads.sourceforge.net/project/fastjar/fastjar/0.94/fastjar-0.94.tar.gz"
  sha256 "5a217fc3e3017efb18fd1316b38d2aaa7370280fcf5732ad8fff7e27ec867b95"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fastjar", "-V"
    system "#{bin}/grepjar", "-V"
  end
end
