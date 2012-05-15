require 'formula'

class GradsSupplementary < Formula
  url 'ftp://grads.iges.org/grads/data2.tar.gz'
  md5 'cacf16d75f53c876ff18bd4f8100fa66'
end

class Grads < Formula
  homepage 'http://www.iges.org/grads/grads.html'
  url 'ftp://iges.org/grads/2.0/grads-2.0.1-bin-darwin9.8-intel.tar.gz'
  md5 '3c94e4e2f840a323df24df5264e159ff'

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
