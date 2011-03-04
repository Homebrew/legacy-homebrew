require 'formula'

class Reposurgeon <Formula
  url 'http://www.catb.org/esr/reposurgeon/reposurgeon-0.7.tar.gz'
  homepage 'http://www.catb.org/esr/reposurgeon/'
  md5 'cede4de54cc56b259c14969afaeeeb7f'

  def install
    bin.install "reposurgeon"
    man1.install "reposurgeon.1"
  end
end
