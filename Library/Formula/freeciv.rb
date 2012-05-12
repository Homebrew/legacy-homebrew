require 'formula'

class Freeciv < Formula
  homepage 'http://freeciv.wikia.com'
  url 'http://downloads.sourceforge.net/project/freeciv/Freeciv%202.3/2.3.2/freeciv-2.3.2.tar.bz2'
  md5 'eee143d8fea4cf3c772a560fee066600'
  head 'svn://svn.gna.org/svn/freeciv/trunk', :using => :svn

  def options
     [['--disable-nls', 'Disable NLS support.'],
      ['--disable-sdl', 'Disable sound support.'],
     ]
  end

  depends_on 'pkg-config' => :build
  depends_on "gtk+"
  depends_on "gettext" unless ARGV.include? "--disable-nls"
  depends_on 'sdl_mixer' unless ARGV.include? "--disable-sdl"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    unless ARGV.include? '--disable-nls'
      gettext = Formula.factory('gettext')
      args << "CFLAGS=-I#{gettext.include}"
      args << "LDFLAGS=-L#{gettext.lib}"
    end

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/freeciv-server -v"
  end
end
