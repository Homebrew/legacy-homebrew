require 'formula'

class Rename < Formula
  homepage 'http://plasmasturm.org/code/rename'
  url 'https://github.com/ap/rename/archive/v1.500.tar.gz'
  sha1 'a1315f57191cf78191b23cd20ebfe3afe7056c7e'

  def install
    system 'pod2man', 'rename', 'rename.1'
    bin.install 'rename'
    man1.install 'rename.1'
  end
end
