require 'formula'

class Mu < Formula
  url 'http://mu0.googlecode.com/files/mu-0.9.8.3.tar.gz'
  sha1 'e66396783b9424cb7bf740bc309bd1361f399d16'
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

  def caveats; <<-EOS.undent
    Existing mu users are recommended to run the following after upgrading:

      mu index --rebuild
    EOS
  end
end
