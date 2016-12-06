require 'formula'

class Waxsim < Formula
  homepage 'https://github.com/max-horvath/WaxSim'
  url 'https://github.com/max-horvath/WaxSim/zipball/1.0.2'
  sha1 '62b56ea4e49df417fc282249ebaf469fcdcc6b55'

  def install
    system "make", "install"
  end
end
