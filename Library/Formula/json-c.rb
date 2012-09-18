require 'formula'

class JsonC < Formula
  homepage 'https://github.com/json-c/json-c/wiki'
  url 'http://oss.metaparadigm.com/json-c/json-c-0.9.tar.gz'
  sha1 'daaf5eb960fa98e137abc5012f569b83c79be90f'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
