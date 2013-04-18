require 'formula'
class Blimp < Formula
  homepage 'https://github.com/elbuo8/blimp-cli/'
  url 'https://github.com/elbuo8/blimp-cli/archive/master.tar.gz'
  sha1 '9db9c2be6ef11f123c8e3ad983b24f8bc2926fd6'
  version '0.1'
  depends_on 'blimp' => :python
  def install
    bin.install 'blimp'
  end
end
