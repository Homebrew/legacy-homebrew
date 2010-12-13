require 'formula'

class Yajl <Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://cloud.github.com/downloads/lloyd/yajl/yajl-1.0.9.tar.gz'
  md5 '8643ff2fef762029e51c86882a4d0fc6'

  # Configure uses cmake, even though it looks like we're
  # just using autotools below.
  depends_on 'cmake' => :build

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (include + 'yajl').install Dir['src/api/*.h']
  end
end
