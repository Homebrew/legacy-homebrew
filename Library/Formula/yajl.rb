require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://github.com/lloyd/yajl/tarball/2.0.0'
  sha256 '752033679036ca32cd938bc73d89096f74d51b049aeb5131ee0d47152b6363d5'

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
