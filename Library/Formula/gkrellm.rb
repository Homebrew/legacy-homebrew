require 'formula'

class Gkrellm < Formula
  homepage 'http://members.dslextreme.com/users/billw/gkrellm/gkrellm.html'
  url 'http://members.dslextreme.com/users/billw/gkrellm/gkrellm-2.3.5.tar.bz2'
  sha1 'bcfc2efb5fd3f27e9bb703bda73f6a1d96b080df'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'atk'
  depends_on 'cairo'
  depends_on 'fontconfig'
  depends_on 'freetype'
  depends_on 'gdk-pixbuf'
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'pango'

  patch :p0 do
    url "https://trac.macports.org/export/115088/trunk/dports/sysutils/gkrellm/files/207a0519ac73290ba65b6e5f7446549a2a66f5d2.patch"
    sha1 "db6342bdecc9ff0470dccbc4b3d10b1c0d078c67"
  end

  patch :p0 do
    url "https://trac.macports.org/export/115088/trunk/dports/sysutils/gkrellm/files/patch-src-Makefile.diff"
    sha1 "419adbc2d41b36a435fa1ba76106b63bf8879df9"
  end

  def install
    inreplace 'Makefile', '$(PREFIX)', prefix
    inreplace 'src/gkrellm.h' do |s|
      s.gsub! '/usr/local/share/gkrellm2/themes', "#{share}/gkrellm2/themes"
      s.gsub! 'src/gkrellm.h', '/usr/share/gkrellm2/themes', "#{share}/gkrellm2/themes"
      s.gsub! 'src/gkrellm.h', '/usr/local/lib/gkrellm2/plugins', "#{libexec}/gkrellm2/plugins"
      s.gsub! 'src/gkrellm.h', '/usr/lib/gkrellm2/plugins', "#{libexec}/gkrellm2/plugins"
    end

    system "make", "darwin9"
    system "make", "install_darwin9"
  end
end
