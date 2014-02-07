require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.6.tar.gz'
  sha1 '29526abfc45dfc04e865e06485aac886306b377f'

  head 'https://github.com/lra/mackup.git'

  depends_on :python

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end

  def test
    system "#{bin}/mackup", '-h'
  end
end
