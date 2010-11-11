require 'formula'

class Reposurgeon <Formula
  url 'http://www.catb.org/esr/reposurgeon/reposurgeon-0.6.tar.gz'
  homepage 'http://www.catb.org/esr/reposurgeon/'
  md5 '1c75cdf5b57595040571dfda85c3ed0f'

  def install
    bin.install "reposurgeon"
    man1.install "reposurgeon.1"
  end
end
