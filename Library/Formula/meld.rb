require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.8/meld-1.8.4.tar.xz'
  sha256 'b46e5786343f236d203037a7ace8f1b28145a51a3f84fa527efcf62f47b5b8de'

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
