require 'formula'

class Glog < Formula
  homepage 'http://code.google.com/p/google-glog/'
  url 'http://google-glog.googlecode.com/files/glog-0.3.3.tar.gz'
  sha1 'ed40c26ecffc5ad47c618684415799ebaaa30d65'

  depends_on 'gflags'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
