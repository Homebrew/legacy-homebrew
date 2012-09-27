require 'formula'

class Glog < Formula
  homepage 'http://code.google.com/p/google-glog/'
  url 'http://google-glog.googlecode.com/files/glog-0.3.2.tar.gz'
  sha1 '94e641e50afd03c574af6a55084e94a347c911d7'

  depends_on 'gflags'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
