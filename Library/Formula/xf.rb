require 'formula'

class Xf < Formula
  homepage 'https://github.com/bytecollective/xf'
  url 'https://github.com/downloads/bytecollective/xf/xf-0.1.0.tar.gz'
  md5 'cff2d95591e721526068b53e5f8ce2d7'

  def install
    bin.install 'xf'
  end
end
