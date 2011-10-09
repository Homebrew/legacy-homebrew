require 'formula'

class Imapfilter < Formula
  url 'http://github.com/downloads/lefcha/imapfilter/imapfilter-2.2.3.tar.gz'
  homepage 'http://github.com/lefcha/imapfilter/'
  md5 'f075ebe22deb50de99303b8282e5eebf'

  depends_on 'lua'
  depends_on 'pcre'

  def install
    system "./configure", "-p", prefix, "-m", man
    system "make"
    system "make install"
  end
end
