require 'brewkit'

class P7zip <Formula
  @url='http://kent.dl.sourceforge.net/sourceforge/p7zip/p7zip_9.04_src_all.tar.bz2'
  @homepage='http://p7zip.sourceforge.net/'
  @md5='9194ebf9a2b3735d236aed001de5f6f8'

  def install
    FileUtils.mv 'makefile.macosx_32bits', 'makefile.machine'
    FileUtils.mv 'DOCS/copying.txt', 'COPYING'
    system "make"
    # we do our own install because theirs sucks
    bin.install 'bin/7za'
    man.install 'man1'
  end
end