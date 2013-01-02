require 'formula'

class Ctemplate < Formula
  homepage 'https://ctemplate.googlecode.com/'
  url 'http://ctemplate.googlecode.com/files/ctemplate-2.2.tar.gz'
  sha1 'b00a35291bc5c5bb8493a68bbf76d6a9cfa5c117'

  head 'http://ctemplate.googlecode.com/svn/trunk/', :using => :svn

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
