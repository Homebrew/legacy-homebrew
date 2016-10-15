require 'formula'

class CanaryCli < Formula
  homepage 'https://github.com/prasmussen/chrome-cli'
  url 'https://drive.google.com/uc?id=0B3X9GlR6EmbnTmZ2VmxRdmxRaFU'
  sha256 '8ff586d400d3bb9bff55c083c5b5f1ac02dad0975b900f37e5388bbac8c21cfb'
  version '1.5.0'

  def install
    mv 'uc', 'canary-cli'
    bin.install 'canary-cli'
  end
end
