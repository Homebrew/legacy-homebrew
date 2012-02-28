require 'formula'

class Pysvn < Formula
  homepage 'http://pysvn.tigris.org/'
  url 'http://pysvn.barrys-emacs.org/source_kits/pysvn-1.7.5.tar.gz'
  md5 '3334718248ec667b17d333aac73d5680'

  def install
    system "python", "setup.py", "build"
    system "mkdir -p #{lib}/python2.7/site-packages/"
    # The build complains if this path is not in the PYTHONPATH
    ENV['PYTHONPATH'] = "#{lib}/python2.7/site-packages/"
    system "python setup.py install --prefix=#{prefix}"
  end

  def test
    system "python -e import pysvn"
  end
end
