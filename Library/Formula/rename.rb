require 'formula'

class Rename < Formula
  homepage 'http://plasmasturm.org/code/rename'
  url 'http://plasmasturm.org/code/rename/rename', :using => :nounzip
  version '1.100'
  sha1 '73156dd7710fdb5d68a01d79af6caab743af5758'

  def install
    system 'pod2man', 'rename', 'rename.1'
    bin.install 'rename'
    man1.install 'rename.1'
  end
end
