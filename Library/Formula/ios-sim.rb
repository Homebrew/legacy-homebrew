require 'formula'

class IosSim < Formula
  url 'https://github.com/Fingertips/ios-sim/tarball/1.3'
  homepage 'https://github.com/Fingertips/ios-sim'
  md5 'd6bd742b00ed3b93bd54bbc55b1901fc'

  def install
    system "rake install prefix='#{prefix}'"
  end
end
