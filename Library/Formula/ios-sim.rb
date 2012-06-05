require 'formula'

class IosSim < Formula
  homepage 'https://github.com/phonegap/ios-sim'
  url 'https://github.com/phonegap/ios-sim/tarball/1.4'
  md5 'c68954b0808119a51641613a2b383c49'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
