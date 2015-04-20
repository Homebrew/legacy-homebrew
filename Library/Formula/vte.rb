require 'formula'

class Vte < Formula
  homepage 'http://developer.gnome.org/vte/'
  url 'http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.0.tar.bz2'
  sha1 '49b66a0346da09c72f59e5c544cc5b50e7de9bc1'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'pygobject'
  depends_on 'pygtk'
  depends_on :python

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--disable-Bsymbolic",
    ]

    if build.with? "python"
      # pygtk-codegen-2.0 has been deprecated and replaced by
      # pygobject-codegen-2.0, but the vte Makefile does not detect this.
      ENV["PYGTK_CODEGEN"] = Formula["pygobject"].bin/'pygobject-codegen-2.0'
      args << "--enable-python"
    end

    system "./configure", *args
    system "make install"
  end
end
