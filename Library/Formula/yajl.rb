require 'formula'

class Yajl <Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://cloud.github.com/downloads/lloyd/yajl/yajl-1.0.8.tar.gz'
  md5 '26116d41b6466f6b4da7d9e8450f2200'

  # Configure uses cmake, even though it looks like we're
  # just using autotools below.
  depends_on 'cmake'

  def install
    ENV.deparallelize

    system "./configure", "--prefix#{prefix}"
    system "make install"
  end
end