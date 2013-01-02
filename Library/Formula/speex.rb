require 'formula'

class Speex < Formula
  url 'http://downloads.us.xiph.org/releases/speex/speex-1.2rc1.tar.gz'
  homepage 'http://speex.org'
  sha1 '52daa72572e844e5165315e208da539b2a55c5eb'

  depends_on 'pkg-config' => :build
  depends_on 'libogg' => :optional

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
