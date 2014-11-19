require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org/'
  url 'http://download.gnome.org/sources/meld/3.12/meld-3.12.1.tar.xz'
  sha256 '8e09284f8d50347386a428e1a2222f2b3a704bf84b3736908082968b5b0dc7f8'

  depends_on 'intltool' => :build
  depends_on 'rarian' => :build
  depends_on :x11
  depends_on :python
  depends_on 'gtk+3'
  depends_on 'glib'
  depends_on 'pygobject3'
  depends_on 'gtksourceview3'
  depends_on 'itstool'
  depends_on 'libxml2' => 'with-python'

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "python", "setup.py", "--no-update-icon-cache", "--no-compile-schemas", "install", "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end
end
