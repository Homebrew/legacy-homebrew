require 'formula'

class Haste < Formula

  url 'https://github.com/seejohnrun/haste-client/tarball/v0.1.1'
  version '0.1.1'
  homepage 'https://github.com/seejohnrun/haste-client'
  md5 'd6a427775b3d2637048a794e860a2e2f'

  # Install haste script
  def install
    lib.install Dir['lib/**/*.rb']
    bin.install 'bin/haste'
  end

end
