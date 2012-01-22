require 'formula'

class Imapfilter < Formula
  url 'https://github.com/downloads/lefcha/imapfilter/imapfilter-2.3.tar.gz'
  homepage 'http://github.com/lefcha/imapfilter/'
  md5 '912bb395d6c377018eaf7d74d2db6636'

  depends_on 'lua'
  depends_on 'pcre'

  def install
    system "make all"
    system "make PREFIX=#{prefix} MANDIR=#{man} install"
  end

  def test
    system "imapfilter -V"
  end
end
