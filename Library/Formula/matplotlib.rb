require 'formula'

class Matplotlib < Formula
  url 'http://sourceforge.net/projects/matplotlib/files/matplotlib/matplotlib-1.0.1/matplotlib-1.0.1.tar.gz/download'
  version "1.0.1"
  homepage 'http://matplotlib.sourceforge.net/'
  md5 '2196c0482d5b33dc8d33f67bbafc1323'

  def install
    # ppc builds are problematic. So just target these architectures
    ENV['ARCH_FLAGS']="-arch i386 -arch x86_64"
    ENV['CFLAGS'] = ENV['ARCH_FLAGS'] 
    ENV['LDFLAGS'] = ENV['ARCH_FLAGS']
    system "python setup.py build"
    system "python setup.py install --prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    The Matplotlib Python module will not work until you edit your PYTHONPATH like so:
      export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.6/site-packages/:$PYTHONPATH"

    To make this permanent, put it in your shell's profile (e.g. ~/.bash_profile).
    EOS
  end
end
