require 'formula'

class GstPluginsBase <Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.29.tar.bz2'
  md5 'd07e251152cccbaa81807c14cf0fd8c0'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'gstreamer'
  depends_on 'liboil'
  depends_on 'gtk+' => :optional
  depends_on 'libogg' => :optional
  depends_on 'pango' => :optional
  depends_on 'theora' => :optional
  depends_on 'libvorbis' => :optional

  def install
    system "autoreconf -f -i" unless File.exist? "configure"
    # gnome-vfs turned off due to lack of formula for it. MacPorts has it.
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
      "--disable-dependency-tracking", "--enable-experimental",
      "--disable-libvisual", "--disable-gst_v4l", "--disable-alsa",
      "--disable-cdparanoia", "--without-x", "--disable-x", "--disable-xvideo",
      "--disable-xshm", "--disable-gnome_vfs"
    system "make"
    system "make install"
  end
end
