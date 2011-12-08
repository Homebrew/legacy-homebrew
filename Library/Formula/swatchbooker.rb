require 'formula'

class Swatchbooker < Formula
  url 'http://launchpad.net/swatchbooker/trunk/0.7.3/+download/SwatchBooker-0.7.3.tar.gz'
  homepage 'http://www.selapa.net/swatchbooker/'
  md5 'd5c2d6d58679b233e2c298381b164acd'

  depends_on 'little-cms'
  depends_on 'pil'
  depends_on 'pyqt'

  def install
    # Tell launching shell scipts where the python code actually is
    inreplace ["data/swatchbooker","data/sbconvert","data/sbconvertor"] do |s|
      s.gsub! "/usr/lib",
              "#{HOMEBREW_PREFIX}/lib"
    end

    system "python", "setup.py", "build"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats; <<-EOS
For the graphical user interface to work, PyQT requires that you amend your PYTHONPATH like so:
    export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
EOS
  end

  def test
    system "swatchbooker"
  end
end
