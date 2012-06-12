require 'formula'

class Osslsigncode < Formula
  homepage 'http://sourceforge.net/projects/osslsigncode/'
  url 'http://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.4.tar.gz'
  md5 '018b12b3efc4a5250dd3977c2bada3cd'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
