require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.8/meld-1.8.2.tar.xz'
  sha1 'da6e4430ea3e56ec649b53f96c485de13a52627f'

  depends_on 'intltool' => :build
  depends_on 'xz' => :build
  depends_on :x11
  depends_on :python
  depends_on 'pygtk'
  depends_on 'pygtksourceview'
  depends_on 'pygobject'
  depends_on 'rarian'

  def install
    system "make", "prefix=#{prefix}", "install"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end
end
