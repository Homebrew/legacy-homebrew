require 'formula'

class Linklint <Formula
  url 'http://linklint.org/download/linklint-2.3.5.tar.gz'
  homepage 'http://linklint.org'
  md5 'c1ae0860199da59ded28771d1fa7b800'

  def install
    mv 'READ_ME.txt', 'README'
    bin.install 'linklint-2.3.5' => 'linklint'
  end
end
