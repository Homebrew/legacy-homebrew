require 'formula'

class Cronolog < Formula
  url 'http://cronolog.org/download/cronolog-1.6.2.tar.gz'
  homepage 'http://cronolog.org/'
  md5 'a44564fd5a5b061a5691b9a837d04979'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
