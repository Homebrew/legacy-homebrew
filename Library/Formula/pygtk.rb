require 'formula'

class Pygtk <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.22/pygtk-2.22.0.tar.bz2'
  homepage 'http://pygtk.org'
  sha256 '4acf0ef2bde8574913c40ee4a43d9c4f43bb77b577b67147271b534501a54cc8'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'libglade'
  depends_on 'pygobject'
  depends_on 'pycairo'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    python_ver = `python -c 'import sys; print sys.version[:3]'`.chomp
    python_lib = "#{HOMEBREW_PREFIX}/lib/python#{python_ver}"
    <<-EOS
This formula won't function until you amend your PYTHONPATH like so:
    export PYTHONPATH=#{python_lib}/site-packages/gtk-2.0:#{python_lib}/site-packages:$PYTHONPATH
EOS
  end

  def test
    python_ver = `python -c 'import sys; print sys.version[:3]'`.chomp
    python_lib = "#{HOMEBREW_PREFIX}/lib/python#{python_ver}"
    ENV.prepend 'PYTHONPATH', "#{python_lib}/site-packages/gtk-2.0:#{python_lib}/site-packages", ':'
    system "pygtk-demo"
  end
end
