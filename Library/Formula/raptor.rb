require 'formula'

class Raptor < Formula
  url 'http://download.librdf.org/source/raptor2-2.0.6.tar.gz'
  homepage 'http://librdf.org/raptor/'
  md5 '1f07af81cbe3cf1bf0d1d250b18d9f93'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
