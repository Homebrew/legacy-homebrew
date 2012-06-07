require 'formula'

class Mldonkey < Formula
  url 'http://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.0/mldonkey-3.1.0.tar.bz2'
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  md5 '072726d158ba1e936c554be341e7ceff'

  depends_on 'objective-caml'

  if ARGV.include? "--with-x"
    depends_on :x11
    depends_on 'librsvg'
    depends_on 'lablgtk'
  end

  def options
    [["--with-x", "Build mldonkey with X11 support"]]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-gui=newgui2" if ARGV.include? '--with-x'

    system "./configure", *args
    system "make install"
  end
end
