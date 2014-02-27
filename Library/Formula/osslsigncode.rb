require 'formula'

class Osslsigncode < Formula
  homepage 'http://sourceforge.net/projects/osslsigncode/'
  url 'https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.6.tar.gz'
  sha1 '83c169638c8c1e0122127674cbb73d2e0e6b5bc2'

  depends_on 'pkg-config' => :build
  depends_on 'openssl'
  depends_on 'libgsf' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
