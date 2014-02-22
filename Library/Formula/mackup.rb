require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.7.tar.gz'
  sha1 '5d8ce05647773bee67e0e1f5c714be6193db16a7'

  head 'https://github.com/lra/mackup.git'

  depends_on :python

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end

  def test
    system "#{bin}/mackup", '--help'
  end
end
