require 'formula'

class Ghunit < Formula

  depends_on :xcode

  homepage 'https://github.com/gabriel/gh-unit'
  url 'https://github.com/gabriel/gh-unit/tarball/0.5.5'
  sha1 '19da294c5c6c8b8d9b425032219387248b87bbca'

  def install
    system "make -C Project-iOS"
    system "make -C Project-MacOSX"
    frameworks = prefix+"Frameworks"
    frameworks.mkdir
    frameworks.install "Project-iOS/build/Framework/GHUnitIOS.framework"
    frameworks.install "Project-MacOSX/build/Release/GHUnit.framework"
  end

end
