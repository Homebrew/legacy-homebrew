require 'formula'

class Libvlc <Formula

  url       'http://downloads.sourceforge.net/project/vlc/1.1.10/vlc-1.1.10.tar.bz2'
  homepage  'http://www.videolan.org'
  md5       '066cb94b1e3aa848d828121354d6be4d'

  def install
    system 'cd extras/contrib && ./bootstrap ' + (snow_leopard_64? ? 'x86_64-apple-darwin10' : nil)
    system 'cd extras/contrib && make'
    system './bootstrap'
    system './configure', '--disable-debug', "--prefix=#{prefix}", (snow_leopard_64? ? '--build=x86_64-apple-darwin10': nil)
    system 'make install'
  end

end
