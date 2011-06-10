require 'formula'

class Psftools < Formula
  url 'http://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz'
  homepage 'http://www.seasip.demon.co.uk/Unix/PSF/'
  md5 '159022aae93a797dbc2a01014acbd115'

  def patches
    # fixes configure to ignore stray .dSYM files
    "https://gist.github.com/raw/1019341/d8d91cb3a1118fa062b7c1579fa9d1c94962450f/psftools.config.patch"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end