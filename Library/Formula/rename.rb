require 'formula'

class Rename < Formula
  homepage 'http://plasmasturm.org/code/rename'
  url 'https://github.com/ap/rename/archive/v1.600.tar.gz'
  sha1 'a7946ce3602e3810aaa70300674ccb26832634ed'

  def install
    system 'pod2man', 'rename', 'rename.1'
    bin.install 'rename'
    man1.install 'rename.1'
  end
end
