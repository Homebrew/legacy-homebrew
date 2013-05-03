require 'formula'

class Swatchbooker < Formula
  homepage 'http://www.selapa.net/swatchbooker/'
  url 'http://launchpad.net/swatchbooker/trunk/0.7.3/+download/SwatchBooker-0.7.3.tar.gz'
  sha1 'fd2e46c278e762dc0c3ed69f824ab620773f153e'

  depends_on 'little-cms' => 'with-python'
  depends_on 'pil'
  depends_on 'pyqt'

  def install
    # Tell launching shell scipts where the python library is
    inreplace %w[data/swatchbooker data/sbconvert data/sbconvertor] do |s|
      s.gsub! "/usr/lib", "#{HOMEBREW_PREFIX}/lib"
    end

    system "python", "setup.py", "build"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    For the graphical user interface to work, PyQT requires that you amend your PYTHONPATH:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
    EOS
  end

  def test
    system "#{bin}/swatchbooker"
  end
end
