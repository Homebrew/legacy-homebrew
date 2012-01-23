require 'formula'

class GradsSupplementary < Formula
  url 'ftp://grads.iges.org/grads/data2.tar.gz'
  md5 'cacf16d75f53c876ff18bd4f8100fa66'
end

class Grads < Formula
  url 'ftp://iges.org/grads/2.0/grads-2.0.1-bin-darwin9.8-intel.tar.gz'
  homepage 'http://www.iges.org/grads/grads.html'
  md5 '3c94e4e2f840a323df24df5264e159ff'
  version '2.0.1'

  def install
    bin.install ['bin/bufrscan', 'bin/grads', 'bin/grib2scan', 'bin/gribmap', 'bin/gribscan', 'bin/gxeps', 'bin/gxps', 'bin/gxtran', 'bin/stnmap', 'bin/wgrib']

    # Install the required supplementary files
    GradsSupplementary.new.brew{ (lib+'grads').install Dir['*'] }
  end

  if HOMEBREW_PREFIX.to_s != '/usr/local'
    def caveats
      <<-EOS.undent
        In order to use the GrADS tools, you will need to set the GADDIR
        environment variable to:
          #{HOMEBREW_PREFIX}/lib/grads
      EOS
    end
  end
end
