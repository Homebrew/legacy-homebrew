require 'formula'

class Ccm < Formula
  homepage 'https://github.com/pcmanus/ccm'
  url 'https://github.com/pcmanus/ccm/archive/ccm-1.1.tar.gz'
  sha1 'cb216c633f04cf1821bfafa7d1c1a2e73444f20e'
  version '1.1'

  head 'https://github.com/pcmanus/ccm.git', :branch => :master

  depends_on :python => ['yaml']

  def install
    system python, "setup.py", "install", "--prefix=#{prefix}"
  end
end
