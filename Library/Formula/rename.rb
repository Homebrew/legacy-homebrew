require 'formula'

class Rename < Formula
  homepage 'http://plasmasturm.org/code/rename'
  url 'http://plasmasturm.org/code/rename/rename'
  version '1.600'
  sha1 '0ef692f0cbbda0ef60aea68e5422f33b7faca794'
  def install
    system 'pod2man', 'rename', 'rename.1'
    bin.install 'rename'
    man1.install 'rename.1'
  end
end
