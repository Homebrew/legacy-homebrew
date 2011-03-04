require 'formula'

class Links <Formula
  url 'http://links.twibright.com/download/links-2.2.tar.gz'
  homepage 'http://links.twibright.com/'
  md5 'c9937f9ed0061f264973182f871fb667'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
