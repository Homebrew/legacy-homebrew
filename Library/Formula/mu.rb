require 'formula'

class Mu <Formula
  url 'http://mu0.googlecode.com/files/mu-0.9.3.tar.gz'
  homepage 'http://www.djcbsoftware.nl/code/mu/'
  md5 '4f19e26c8621fcace290f78abecf2d36'

  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gmime'
  depends_on 'xapian'

  def install
    system  "./configure", "--prefix=#{prefix}",
      "--disable-dependency-tracking", "--with-gui=none"
    system "make"
    system "make install"
  end
end
