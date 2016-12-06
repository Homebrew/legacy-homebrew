require 'formula'

class E < Formula
  version '0.1.0'
  url 'https://github.com/knu/e.git', :tag => version
  head 'https://github.com/knu/e.git'
  homepage 'https://github.com/knu/e'

  def install
    bin.install 'e'
  end
end
