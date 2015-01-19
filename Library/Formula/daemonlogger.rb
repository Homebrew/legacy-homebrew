class Daemonlogger < Formula
  homepage "http://sourceforge.net/projects/daemonlogger/"
  url "https://downloads.sourceforge.net/project/daemonlogger/daemonlogger-1.2.1.tar.gz"
  sha1 "ce0aa20b38f18eca94a6d00fe9126d441fe2818a"

  depends_on "libdnet"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/daemonlogger", "-h"
  end
end
