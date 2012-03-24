require 'formula'

class Freeciv < Formula
  homepage 'http://freeciv.wikia.com'
  url 'http://downloads.sourceforge.net/project/freeciv/Freeciv%202.3/2.3.1/freeciv-2.3.1.tar.bz2'
  md5 'efce9b2cd8b7a36017f1ebce59236dcb'
  head 'svn://svn.gna.org/svn/freeciv/trunk', :using => :svn

  def options
     [['--disable-nls', 'Disable NLS support.']]
  end

  depends_on 'pkg-config' => :build
  depends_on "gtk+"
  depends_on "gettext" unless ARGV.include? "--disable-nls"

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
