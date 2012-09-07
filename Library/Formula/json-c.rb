require 'formula'

class JsonC < Formula
  url 'http://oss.metaparadigm.com/json-c/json-c-0.9.tar.gz'
  homepage 'http://oss.metaparadigm.com/json-c/'
  sha1 'daaf5eb960fa98e137abc5012f569b83c79be90f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
