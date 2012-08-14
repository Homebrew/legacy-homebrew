require 'formula'

class Funcoeszz < Formula
  homepage 'http://funcoeszz.googlecode.com/'
  url 'http://funcoeszz.googlecode.com/files/funcoeszz-10.12.sh'
  md5 '93f69412f97a38ecb80493279440b5f0'

  def install
    prefix.install "funcoeszz-10.12.sh"
  end

  def caveats; <<-EOS.undent
    To use this software add to your profile:
      source #{prefix}/funcoeszz-10.12.sh
    EOS
  end
end
