require 'formula'

class Zopfli < Formula
  homepage 'https://code.google.com/p/zopfli/'
  url 'https://zopfli.googlecode.com/files/zopfli-1.0.0.zip'
  sha1 '98ea00216e296bf3a13e241d7bc69490042ea7ce'
  head 'https://code.google.com/p/zopfli/', :using => :git

  def install
    # Makefile hardcodes gcc
    inreplace 'Makefile', 'gcc', ENV.cc
    system 'make'
    bin.install 'zopfli'
  end

  test do
    system "#{bin}/zopfli"
  end
end
