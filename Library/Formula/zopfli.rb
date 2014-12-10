require 'formula'

class Zopfli < Formula
  homepage 'https://code.google.com/p/zopfli/'
  url 'https://zopfli.googlecode.com/files/zopfli-1.0.0.zip'
  sha1 '98ea00216e296bf3a13e241d7bc69490042ea7ce'
  head 'https://code.google.com/p/zopfli/', :using => :git

  def install
    # Makefile hardcodes gcc
    inreplace 'makefile', 'gcc', ENV.cc
    system 'make', '-f', 'makefile'
    bin.install 'zopfli'
    if build.head?
      system 'make', '-f', 'makefile', 'zopflipng'
      bin.install 'zopflipng'
    end
  end

  test do
    system "#{bin}/zopfli"
  end
end
