require 'formula'

class Mldonkey < Formula
  url 'http://downloads.sourceforge.net/project/mldonkey/mldonkey/3.0.7/mldonkey-3.0.7.tar.bz2'
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  md5 '162b78fc4e20335a8fe31d91e1656db2'

  depends_on 'objective-caml'
  if ARGV.include? "--with-x"
    depends_on 'librsvg'
    depends_on 'lablgtk'
  end

  def options
    [["--with-x", "Build mldonkey with X11 support"]]
  end

  def install
    args = ["--prefix=#{prefix}"]

    if ARGV.include? "--with-x"
      args << "--enable-gui=newgui2"
    end

    system "./configure", *args
    system "make install"
  end
end
