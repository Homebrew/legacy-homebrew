require 'formula'

class Rename < Formula
  url 'http://plasmasturm.org/code/rename/rename', :using => :nounzip
  version '0.1.3'
  homepage 'http://plasmasturm.org/code/rename'
  sha1 'a2235a402d18495513edf690445e0030f31c9ab3'

  def install
    system 'pod2man', 'rename', 'rename.1'
    bin.install 'rename'
    man1.install 'rename.1'
  end
end
