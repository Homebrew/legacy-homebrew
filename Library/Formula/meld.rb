require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.8/meld-1.8.5.tar.xz'
  sha256 'e0f1d6007117a4be95d7c399359cb2ebfa80f2b9158222d727e9a35ae4d5d44d'

  depends_on 'intltool' => :build
  depends_on 'rarian' => :build
  depends_on :x11
  depends_on :python
  depends_on 'pygtk'
  depends_on 'pygtksourceview'
  depends_on 'pygobject'

  def install
    system "make", "prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end
end
