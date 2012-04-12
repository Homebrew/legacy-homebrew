require 'formula'

class JsonC < Formula
  url 'http://oss.metaparadigm.com/json-c/json-c-0.9.tar.gz'
  homepage 'http://oss.metaparadigm.com/json-c/'
  md5 '3a13d264528dcbaf3931b0cede24abae'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
