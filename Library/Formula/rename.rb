require 'formula'

class Rename < Formula
  homepage 'http://plasmasturm.org/code/rename'
  url 'http://plasmasturm.org/code/rename/rename', :using => :nounzip
  version '1.100'
  sha1 '2077cdb11878ffeaefa32063e29af87d8ad7a596'

  def install
    system 'pod2man', 'rename', 'rename.1'
    bin.install 'rename'
    man1.install 'rename.1'
  end
end
