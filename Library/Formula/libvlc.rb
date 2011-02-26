require 'formula'

class Libvlc <Formula

  url       'http://downloads.sourceforge.net/project/vlc/1.1.7/vlc-1.1.7.tar.bz2'
  homepage  'http://www.videolan.org'
  md5       '932ce1fa4afa54b56ac0ccc0655667b6'

  def install
    system 'cd extras/contrib && ./bootstrap ' + (snow_leopard_64? ? 'x86_64-apple-darwin10' : nil)
    system 'cd extras/contrib && make'
    system './bootstrap'
    system './configure', '--disable-debug', "--prefix=#{prefix}", (snow_leopard_64? ? '--build=x86_64-apple-darwin10': nil)
    system 'make install'
  end

end
