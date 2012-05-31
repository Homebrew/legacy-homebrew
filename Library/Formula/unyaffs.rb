require 'formula'

class Unyaffs < Formula
  head 'http://unyaffs.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/unyaffs/'

  def install
    system "#{ENV.cc} #{ENV.cflags} -o unyaffs unyaffs.c"
    bin.install 'unyaffs'
  end
end
