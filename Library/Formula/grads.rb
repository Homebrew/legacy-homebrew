require 'formula'

class Grads < Formula
  homepage 'http://www.iges.org/grads/grads.html'
  url 'ftp://cola.gmu.edu/grads/2.0/grads-2.0.2-bin-darwin9.8-intel.tar.gz'
  sha1 '0d42581c614ae627f4b53113c16c0695bd233362'

  # required supplementary files
  resource 'data2' do
    url 'ftp://cola.gmu.edu/grads/data2.tar.gz'
    sha1 'e1cd5f9c4fe8d6ed344a29ee00413aeb6323b7cd'
  end

  def install
    rm 'bin/INSTALL'
    prefix.install 'bin/COPYRIGHT', 'bin'
    (lib/'grads').install resource('data2')
  end

  def caveats; <<-EOS.undent
    In order to use the GrADS tools, you may need to set some environmental
    variables. See the documentation at:
      http://www.iges.org/grads/gadoc/gradcomdgrads.html
    EOS
  end
end
