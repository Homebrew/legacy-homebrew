require 'formula'

class Ensemble < Formula
  url 'https://launchpad.net/~ensemble/+archive/ppa/+files/ensemble_0.5%2Bbzr339-0ensemble1%7Eoneiric1.tar.gz'
  md5 'ccd4dc22f0e6ab27417e3c060961c216'
  homepage 'https://ensemble.ubuntu.com/'
  version = '0.5+bzr339'

  depends_on 'zookeeper'
  depends_on 'txaws' => :python
  depends_on 'zope.interface' => :python
  depends_on 'twisted' => :python
  depends_on 'txzookeeper' => :python
  depends_on 'argparse' => :python
  depends_on 'yaml' => :python

  def install
    system "python", "setup.py", "install"
    bin.install "bin/ensemble"
  end

  def caveats; <<-EOS.undent
    This formula installs Ensemble against whatever Python is first in your path.
    You will need to easy_install or pip install the dependent libraries for Ensemble.
    'pip install txaws zope.interface twisted txzookeeper zkpython argparse yamlconfig'
    EOS
  end
end
