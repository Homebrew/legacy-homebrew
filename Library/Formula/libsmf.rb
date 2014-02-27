require 'formula'

class Libsmf < Formula
  homepage 'http://sourceforge.net/projects/libsmf/'
  url 'https://downloads.sourceforge.net/project/libsmf/libsmf/1.3/libsmf-1.3.tar.gz'
  sha1 'b2fb0ece095e77f04a9ff7532a88fe79533b2c47'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
