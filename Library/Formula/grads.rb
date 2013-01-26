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
    prefix.install 'bin/COPYRIGHT'
    prefix.install 'bin'

    # Install the required supplementary files
    GradsSupplementary.new.brew{ (lib+'grads').install Dir['*'] }
  end

  def caveats
    if HOMEBREW_PREFIX.to_s != '/usr/local' then <<-EOS.undent
      In order to use the GrADS tools, you will need to set the GADDIR
      environment variable to:
        #{HOMEBREW_PREFIX}/lib/grads
      EOS
    end
  end
end
