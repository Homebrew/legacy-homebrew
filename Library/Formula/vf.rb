require 'formula'

class Vf < Formula
  url 'https://github.com/glejeune/vf/tarball/0.0.1'
  homepage 'https://github.com/glejeune/vf'
  md5 'c1d1c7dd52a960b01c5870165593dc35'

  head 'https://github.com/glejeune/vf.git'

  def install
    # Since the shell file is sourced instead of run
    # install to prefix instead of bin
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To complete installation, add the following line to your shell's rc file:
      source #{prefix}/vf.sh
    EOS
  end
end
