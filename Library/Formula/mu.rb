require 'formula'

class Mu < Formula
  url 'http://mu0.googlecode.com/files/mu-0.9.8.1.tar.gz'
  sha1 '13c504e7feb07aee76554acc3dfe386289aee07b'
  homepage 'http://www.djcbsoftware.nl/code/mu/'
  head 'https://github.com/djcb/mu.git'

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
