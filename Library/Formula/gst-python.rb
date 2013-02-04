require 'formula'

class GstPython < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-python/gst-python-0.10.22.tar.bz2'
  sha1 '7012445d921ae1b325c162500750c9b0e777201f'

  depends_on 'pkg-config' => :build
  depends_on 'gst-plugins-base'
  depends_on 'pygtk'

  def install
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

  test do
    (testpath/'test.py').write <<-EOS.undent
      #!/usr/bin/env python

      import time

      import pygst
      pygst.require('0.10')
      import gst

      import gobject
      gobject.threads_init()

      def main():
          pipeline = gst.parse_launch(
              'audiotestsrc ! audioresample ! fakesink')
          pipeline.set_state(gst.STATE_PLAYING)
          time.sleep(3)

      if __name__ == "__main__":
          main()
    EOS
    system "chmod +x test.py"
    system "./test.py"
  end
end
