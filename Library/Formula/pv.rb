require 'brewkit'

# TODO other names include Pipe Viewer

class Pv <Formula
  @url='http://pipeviewer.googlecode.com/files/pv-1.1.4.tar.bz2'
  @homepage='http://www.ivarch.com/programs/pv.shtml'
  @md5='63033e090d61a040407bfd043aeb6d27'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
