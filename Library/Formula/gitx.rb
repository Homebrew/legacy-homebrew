require 'formula'

class Gitx <Formula
  url 'http://cloud.github.com/downloads/brotherbard/gitx/GitX%20Sep-20-2010.2.zip'
  version '0.7.1'
  homepage 'http://github.com/brotherbard/gitx'
  md5 'd4a3d53b61ded43c687bbd1188251817'

  def install
    prefix.install "../GitX.app"

    bin.mkpath
    ln_s prefix+"GitX.app/Contents/Resources/gitx", bin+"gitx"
  end
end
