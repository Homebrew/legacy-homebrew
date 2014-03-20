require 'formula'

class Libpcl < Formula
  homepage 'http://xmailserver.org/libpcl.html'
  url 'http://xmailserver.org/pcl-1.12.tar.gz'
  sha1 'a206c8fb5a96e65005f414ac46aeccd4b3603c8d'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
