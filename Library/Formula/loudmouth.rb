require 'formula'

class Loudmouth < Formula
  homepage 'http://www.loudmouth-project.org/'
  url 'http://mcabber.com/files/loudmouth-1.4.3-20111204.tar.bz2'
  sha1 '38010a74d28fa06624b7461e515aec47c0ff140e'
  version '1.4.3.111204'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libidn'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
