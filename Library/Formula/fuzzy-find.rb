require 'formula'

class FuzzyFind < Formula
  homepage 'https://github.com/silentbicycle/ff'
  url 'https://github.com/silentbicycle/ff/archive/v0.5-first-form.tar.gz'
  sha1 '698526ae2c725763da0990a4112632ac4b3194c8'
  head 'https://github.com/silentbicycle/ff.git'

  version '0.5'

  def install
    system 'make'
    bin.install 'ff'
  end

  test do
    system 'ff', '-t'
  end
end
