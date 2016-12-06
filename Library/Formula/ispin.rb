require 'formula'

class Ispin < Formula
  homepage 'http://spinroot.com/spin/Src/index.html'
  url 'http://spinroot.com/spin/Src/ispin.tcl'
  version '1.1.0'
  sha1 'e0b99e07c6f36e944c709d427a1565bf911dc3f6'

  depends_on 'spin'

  def install
    bin.install "ispin.tcl" => "ispin"
  end

end