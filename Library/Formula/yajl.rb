require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'https://github.com/lloyd/yajl/archive/2.0.4.tar.gz'
  sha256 '0e78f516dc53ecce7dc073f9a9bb0343186b58ef29dcd1dad74e5e853b216dd5'

  # Configure uses cmake internally
  depends_on 'cmake' => :build

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (include/'yajl').install Dir['src/api/*.h']
  end
end
