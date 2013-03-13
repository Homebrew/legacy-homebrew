require 'formula'

class Pygtk < Formula
  homepage 'http://www.pygtk.org/'
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2'
  sha1 '344e6a32a5e8c7e0aaeb807e0636a163095231c2'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'atk'
  depends_on 'pygobject'
  depends_on 'py2cairo'
  depends_on 'libglade' if build.include? 'glade'

  option :universal
  option 'glade', 'Python bindigs for glade. (to `import gtk.glade`)'

  def install
    ENV.append 'CFLAGS', '-ObjC'
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Fixing the pkgconfig file to find codegen, because it was moved from
    # pygtk to pygobject. But our pkgfiles point into the cellar and in the
    # pygtk-cellar there is no pygobject.
    inreplace lib/'pkgconfig/pygtk-2.0.pc', 'codegendir=${datadir}/pygobject/2.0/codegen', "codegendir=#{HOMEBREW_PREFIX}/share/pygobject/2.0/codegen"
  end

  def caveats; <<-EOS.undent
    For non-Homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  test do
    (testpath/'test.py').write <<-EOS.undent
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
    chmod 0755, 'test.py'
    system "./test.py"
  end
end
