require 'formula'

class Libvlc <Formula

  url       'http://downloads.sourceforge.net/project/vlc/1.1.10/vlc-1.1.10.tar.bz2'
  homepage  'http://www.videolan.org'
  md5       '066cb94b1e3aa848d828121354d6be4d'

  def install
    system './configure',
        "--prefix=#{prefix}",
        '--disable-macosx-defaults',
        '--build=x86_64-apple-darwin10'
        '--with-macosx-sdk=/Developer/SDKs/MacOSX10.6.sdk/',
        '--disable-lua',
        '--disable-vcdx',
        '--disable-mad',
        '--disable-postproc',
        '--disable-a52',
        '--disable-fribidi',
        '--disable-qt4',
        '--disable-skins2',
        '--disable-vlc',
        '--disable-libgcrypt',
        '--disable-remoteosd',
    system 'make'
    system 'make install'
  end

end
