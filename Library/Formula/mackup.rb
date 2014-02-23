require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.7.tar.gz'
  sha1 '6876f5b08c80f1ff11570e5a1db073a2c080dcf2'

  head 'https://github.com/lra/mackup.git'

  depends_on :python

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end

  def test
    system "#{bin}/mackup", '--help'
  end
end
