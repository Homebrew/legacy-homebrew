require 'formula'

class QcaOssl <Formula
  url 'http://delta.affinix.com/download/qca/2.0/plugins/qca-ossl-2.0.0-beta3.tar.bz2'
  homepage 'http://delta.affinix.com/qca/'
  md5 'bdc62c01321385c7da8d27b3902910ce'

  depends_on 'qt'
  depends_on 'qca'

  def patches
    # qca-ossl-2.0.0-beta3 will not build against the current release of OpenSSL without being patched
    "http://home.earthlink.net/~tyrerj/kde/KDE-4/qca-ossl.patch"
  end

  def install
    system "./configure"
    system "make"
    system "make install"
  end
end
