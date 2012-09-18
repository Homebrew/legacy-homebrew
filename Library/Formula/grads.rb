require 'formula'

class GradsSupplementary < Formula
  url 'ftp://grads.iges.org/grads/data2.tar.gz'
  md5 'cacf16d75f53c876ff18bd4f8100fa66'
end

class Grads < Formula
  homepage 'http://www.iges.org/grads/grads.html'
  url 'ftp://cola.gmu.edu/grads/2.0/grads-2.0.1-bin-darwin9.8-intel.tar.gz'
  sha1 '29191df3e25e9c7b70e730fcb7ddb65903e32a80'

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
