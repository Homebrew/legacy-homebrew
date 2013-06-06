require 'formula'

class Vf < Formula
  homepage 'https://github.com/glejeune/vf'
  url 'https://github.com/glejeune/vf/archive/0.0.1.tar.gz'
  sha1 '288086b41857c292207f0dc1c69e0f4435e0195b'

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
