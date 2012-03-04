require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://github.com/lloyd/yajl/tarball/2.0.4'
  sha256 'c19b9691cf15f22e74d903cd06ac9ba5e1e216e6a1b82bfe787c3b48a25bc118'

  # Configure uses cmake internally
  depends_on 'cmake' => :build

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (include + 'yajl').install Dir['src/api/*.h']
  end
end
