require 'formula'

class Unyaffs <Formula
  head 'http://unyaffs.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/unyaffs/'

  def install
      cc_args = ENV['CFLAGS'].split(' ')
      (cc_args << ['-o', 'unyaffs', 'unyaffs.c']).flatten!
      system ENV.cc, *cc_args
      
      bin.install 'unyaffs'
  end
end
