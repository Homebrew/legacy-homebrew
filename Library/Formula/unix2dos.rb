require 'formula'

class Unix2dos < Formula
  url 'http://www.sfr-fresh.com/linux/misc/old/unix2dos-2.2.src.tar.gz'
  md5 'caf9f33155073d3efd310eff9103170b'
  homepage 'http://www.sfr-fresh.com/linux/misc/'

  def install
    # we don't use the Makefile as it doesn't optimize
    system "#{ENV.cc} #{ENV['CFLAGS']} unix2dos.c -o unix2dos"

    bin.install %w[unix2dos]
    man1.install %w[unix2dos.1]
  end
end
