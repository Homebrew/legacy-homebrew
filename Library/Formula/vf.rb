require 'formula'

class Vf < Formula
  version "0.0.0-r61920"
  url 'https://github.com/glejeune/vf/tarball/master'
  homepage 'https://github.com/glejeune/vf'
  md5 'df8e9f57803467ffe9241701244c9cf5'
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
