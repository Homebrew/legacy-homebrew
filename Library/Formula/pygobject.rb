require 'formula'

class Pygobject < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2'
  homepage 'http://live.gnome.org/PyGObject'
  md5 'a43d783228dd32899e6908352b8308f3'

  depends_on 'py2cairo'
  depends_on 'gobject-introspection'

  def install
    ffi_prefix = `brew --prefix libffi`.chomp

    ENV['PKG_CONFIG_PATH'] = "#{ffi_prefix}/lib/pkgconfig:#{ENV['PKG_CONFIG_PATH']}"

    system "./configure --prefix=#{prefix} --disable-dependency-tracking"
    system "make install"
  end

  def test
    system "python -c'import gi'"
  end

end
