require 'formula'

class Ilmbase < Formula
  homepage 'http://www.openexr.com/'
  url 'http://download.savannah.gnu.org/releases/openexr/ilmbase-2.1.0.tar.gz'
  sha1 '306d76e7a2ac619c2f641f54b59dd95576525192'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

