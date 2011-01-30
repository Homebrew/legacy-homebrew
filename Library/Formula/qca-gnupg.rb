require 'formula'

class QcaGnupg <Formula
  url 'http://delta.affinix.com/download/qca/2.0/plugins/qca-gnupg-2.0.0-beta3.tar.bz2'
  homepage 'http://delta.affinix.com/qca/'
  md5 '9b4d020efd835a52d98b2ced9ae79c4b'

  depends_on 'qt'
  depends_on 'qca'

  def install
    system "./configure"
    system "make"
    system "make install"
  end
end
