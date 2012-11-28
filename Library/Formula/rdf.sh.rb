require 'formula'

class RdfSh < Formula
  homepage 'https://github.com/seebi/rdf.sh'
  url 'https://github.com/seebi/rdf.sh/archive/v0.5.tar.gz'
  version '0.5'
  sha1 '457740f1896a686ba46edc96ffb6e4b6e88fd9c7'

  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'curl'

  def install
    bin.install('rdf.sh' => 'rdf')
    man1.install('rdf.1')
    # todo: how to install zsh autocompletion?
  end

  def test
    system "rdf"
  end
end
