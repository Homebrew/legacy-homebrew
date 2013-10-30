require 'formula'

class Lsusb < Formula
  homepage 'https://github.com/jlhonora/homebrew'
  url 'https://raw.github.com/jlhonora/lsusb/fdf36d393881d0ba479988a8e890afdb6544753b/lsusb'
  sha1 '7603057721c16af33eb48e4b631d4a595b13dba0'
  version '0.1'

  def install
    system "chmod +x lsusb"
    system "cp lsusb /usr/local/bin"
  end

  test do
    system "true"
  end
end
