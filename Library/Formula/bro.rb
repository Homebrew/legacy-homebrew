require 'formula'

class Bro < Formula
  url 'http://www.bro-ids.org/downloads/beta/bro-2.0-beta.tar.gz'
  homepage 'http://www.bro-ids.org/'
  md5 '621526dffd9cc57f34d96030481ccf2e'
  version '2.0-BETA'
  depends_on 'cmake'
  depends_on 'swig'
  depends_on 'libmagic'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
