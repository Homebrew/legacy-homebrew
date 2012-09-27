require 'formula'

class Talloc < Formula
  url 'http://www.samba.org/ftp/talloc/talloc-2.0.7.tar.gz'
  homepage 'http://talloc.samba.org/'
  sha1 'fb84ee401b6e094503056b030ce31fcbcc9d06aa'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-rpath"
    system "make install"
  end
end
