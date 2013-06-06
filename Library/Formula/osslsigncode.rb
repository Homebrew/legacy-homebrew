require 'formula'

class Osslsigncode < Formula
  homepage 'http://sourceforge.net/projects/osslsigncode/'
  url 'http://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.5.2.tar.gz'
  sha1 'b33139d3fe41fa4dd8093d325fd02d165314a48b'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
