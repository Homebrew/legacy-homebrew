class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/archive/1.0.1.tar.gz'
  sha1 'aeb3f9c6f8f9e4355016e3255429bcad5c7a5689'
  
  def caveats; <<-EOS.undent
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):
      eval "$(fasd --init auto)"
    EOS
  end

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
