require 'formula'

class Lsusb < Formula
  homepage 'https://github.com/jlhonora/homebrew'
  url 'https://raw.github.com/jlhonora/lsusb/fdf36d393881d0ba479988a8e890afdb6544753b/lsusb'
  sha1 '7603057721c16af33eb48e4b631d4a595b13dba0'
  version '0.1'
  head 'https://github.com/jlhonora/lsusb.git'
  
  depends_on 'wget'

  def install
    system "wget https://raw.github.com/jlhonora/lsusb/master/man/lsusb.1"
    bin.install('lsusb')
    man1.install('lsusb.1')
  end

  test do
    system "true"
  end
end
