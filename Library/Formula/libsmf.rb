require 'formula'

class Libsmf < Formula
  url 'http://downloads.sourceforge.net/project/libsmf/libsmf/1.3/libsmf-1.3.tar.gz'
  homepage 'http://sourceforge.net/projects/libsmf/'
  sha1 'b2fb0ece095e77f04a9ff7532a88fe79533b2c47'

  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
