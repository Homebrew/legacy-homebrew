require 'formula'

class Funcoeszz < Formula
  url 'http://funcoeszz.googlecode.com/files/funcoeszz-10.12.sh'
  homepage 'http://funcoeszz.googlecode.com/'
  md5 '93f69412f97a38ecb80493279440b5f0'
  version '10.12'

  def install
    prefix.install "funcoeszz-#{@version}.sh"
  end

  def caveats
    s = <<-EOS.undent
       To all functions work add 'source #{prefix}/funcoeszz-#{@version}.sh' to your ~/.bash_profile
    EOS
  end
end
