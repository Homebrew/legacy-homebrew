require 'formula'

class Pygtk < Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2'
  homepage 'http://www.pygtk.org/'
  md5 'a1051d5794fd7696d3c1af6422d17a49'

  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'pygobject'
  depends_on 'py2cairo'

  def options
    [["--universal", "Builds a universal binary"]]
  end

  def install
    ENV.append 'CFLAGS', '-ObjC'
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    For non-Homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def test
    mktemp do
      (Pathname.pwd+'test.py').write <<-EOS.undent
        #!/usr/bin/env python
        import pygtk
        pygtk.require('2.0')
        import gtk

        class HelloWorld(object):
            def hello(self, widget, data=None):
                print "Hello World"

            def delete_event(self, widget, event, data=None):
                print "delete event occurred"
                return False

            def destroy(self, widget, data=None):
                print "destroy signal occurred"
                gtk.main_quit()

            def __init__(self):
                self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
                self.window.connect("delete_event", self.delete_event)
                self.window.connect("destroy", self.destroy)
                self.window.set_border_width(10)
                self.button = gtk.Button("Hello World")
                self.button.connect("clicked", self.hello, None)
                self.button.connect_object("clicked", gtk.Widget.destroy, self.window)
                self.window.add(self.button)
                self.button.show()
                self.window.show()

            def main(self):
                gtk.main()

        if __name__ == "__main__":
            hello = HelloWorld()
            hello.main()
      EOS
      system "chmod +x test.py"
      system "./test.py"
    end
  end
end
