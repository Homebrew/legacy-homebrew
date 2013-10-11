require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.0.tar.gz'
  sha1 '0916d5909f43cac6a9c1dfaf1e81b4ff83363f81'

  def install
    bin.install 'q'
  end
end

