require 'formula'

class Yajl <Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://cloud.github.com/downloads/lloyd/yajl/yajl-1.0.7.tar.gz'
  md5 'bb201150143352b117be702a1bc78405'

  # Configure uses cmake, even though it looks like we're
  # just using autotools below.
  depends_on 'cmake'

  def install
    ENV.deparallelize

    system "./configure --prefix '#{prefix}'"
    system "make install"
  end
end
