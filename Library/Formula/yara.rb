require 'formula'

class Yara <Formula
  url 'http://yara-project.googlecode.com/files/yara-1.4.tar.gz'
  homepage 'http://code.google.com/p/yara-project/'
  md5 'ecc744a67482dc9d717936ccd69dc39f'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
