require 'formula'

class Vf < Formula
  homepage 'https://github.com/glejeune/vf'
  url 'https://github.com/glejeune/vf/tarball/0.0.1'
  sha1 '7284328776ada13bafd91e08b8cc90f1239e96b5'

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
