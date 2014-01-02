require 'formula'

class Disktype < Formula
  homepage 'http://disktype.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/disktype/disktype/9/disktype-9.tar.gz'
  sha1 '5ccc55d1c47f9a37becce7336c4aa3a7a43cc89c'

  head 'cvs://:pserver:anonymous@disktype.cvs.sourceforge.net:/cvsroot/disktype:disktype'

  def install
    system "make"
    bin.install "disktype"
    man1.install "disktype.1"
  end
end
