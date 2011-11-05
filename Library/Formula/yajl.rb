require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://github.com/lloyd/yajl/tarball/2.0.2'
  sha256 '4917049b7700e289d38e0ac82f63b7182a5dfc6cf21c5eb9a26d70b6d2e7b68b'

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
