require 'formula'

class GradsSupplementary < Formula
  url 'ftp://cola.gmu.edu/grads/data2.tar.gz'
  sha1 'e1cd5f9c4fe8d6ed344a29ee00413aeb6323b7cd'
end

class Grads < Formula
  homepage 'http://www.iges.org/grads/grads.html'
  url 'ftp://cola.gmu.edu/grads/2.0/grads-2.0.2-bin-darwin9.8-intel.tar.gz'
  sha1 '0d42581c614ae627f4b53113c16c0695bd233362'

  def install
    rm 'bin/INSTALL'
    prefix.install 'bin/COPYRIGHT', 'bin'

    # Install the required supplementary files
    GradsSupplementary.new.brew{ (lib+'grads').install Dir['*'] }
  end

  def caveats; <<-EOS.undent
    In order to use the GrADS tools, you may need to set some environmental
    variables. See the documentation at:
      http://www.iges.org/grads/gadoc/gradcomdgrads.html
    EOS
  end
end
