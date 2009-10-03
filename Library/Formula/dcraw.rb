require 'brewkit'

class Dcraw <Formula
  head 'http://www.cybercom.net/~dcoffin/dcraw/dcraw.c'
  homepage 'http://www.cybercom.net/~dcoffin/dcraw/'
  md5 'cd5cb6e56d5b925c59680abe24b9b03a'

  depends_on 'jpeg'
  depends_on 'liblcms'

  def install
    cc = ENV['CC'] || 'gcc'
    system "#{cc} -o dcraw #{ENV['CFLAGS']} dcraw.c -lm -ljpeg -llcms"
    bin.install 'dcraw'
  end
end
