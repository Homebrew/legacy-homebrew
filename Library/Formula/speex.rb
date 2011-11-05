require 'formula'

class Speex < Formula
  url 'http://downloads.us.xiph.org/releases/speex/speex-1.2rc1.tar.gz'
  homepage 'http://speex.org'
  md5 'c4438b22c08e5811ff10e2b06ee9b9ae'

  depends_on 'pkg-config' => :build
  depends_on 'libogg' => :optional

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
