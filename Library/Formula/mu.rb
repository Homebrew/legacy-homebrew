require 'formula'

class Mu < Formula
  url 'http://mu0.googlecode.com/files/mu-0.9.7.tar.gz'
  sha1 '8641d579a770d59124b72433712841736d326ca6'
  homepage 'http://www.djcbsoftware.nl/code/mu/'
  head 'git://gitorious.org/mu/old.git'

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
