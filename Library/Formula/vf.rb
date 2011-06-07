require 'formula'

class Vf < Formula
  version "0.0.1"
  url 'https://github.com/glejeune/vf/tarball/0.0.1'
  homepage 'https://github.com/glejeune/vf'
  md5 'c1d1c7dd52a960b01c5870165593dc35'
  head 'git://github.com/glejeune/vf.git'

  def install
    bin.install Dir['*']
  end

  def caveats; <<-EOS.undent
    #{name} has been installed to:
    #{bin}

    To complete installation, add the following line in your .bashrc, .zshrc, .your shellrc :

      source #{bin}/vf.sh

    EOS
  end
end
