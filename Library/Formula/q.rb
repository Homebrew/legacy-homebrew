require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.1.5.tar.gz'
  sha1 'f64cb6797c73950b28c404389a3efe2d086d081d'

  def install
    bin.install 'q'
  end
end

