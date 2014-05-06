require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.7.2.tar.gz'
  sha1 '316417a29b2e8d44111f2bc63c6503ed08bddf9c'

  head 'https://github.com/lra/mackup.git'

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/mackup", '--help'
  end
end
