require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.8/meld-1.8.6.tar.xz'
  sha256 'af96682b8f4bf3ad4221c853b1516218d62a17ff43c38f4a83e7e8ac6736e8a5'

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
