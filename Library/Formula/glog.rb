require 'formula'

class Glog <Formula
  # Stable tarball doesn't build on OS X, but trunk does
  #url 'http://google-glog.googlecode.com/files/glog-0.3.0.tar.gz'
  head 'http://google-glog.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/google-glog/'
  md5 '968fe4bfbaddba315bf52de310dcadc5'

  depends_on 'gflags'

  def install
    system "autoreconf -f -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
