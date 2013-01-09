require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.16.1/aria2-1.16.1.tar.bz2'
  sha1 '72317a926d1b32cb200c341069744c7e331ac7b1'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'

  # Leopard's libxml2 is too old.
  depends_on 'libxml2' if MacOS.version == :leopard

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
