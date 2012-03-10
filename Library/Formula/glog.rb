require 'formula'

class Glog < Formula
  homepage 'http://code.google.com/p/google-glog/'
  url 'http://google-glog.googlecode.com/files/glog-0.3.2.tar.gz'
  md5 '897fbff90d91ea2b6d6e78c8cea641cc'

  depends_on 'gflags'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
