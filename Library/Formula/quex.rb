require 'formula'

class Quex < Formula
  url 'http://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.59.2.zip'
  homepage 'http://quex.org/'
  md5 'ccccfb69c1a5436817e28c19268e840b'

  def install
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec + 'quex-exe.py', bin + 'quex'
  end

  def caveats; <<-EOS.undent
    To finish installing quex add the following line to ~/.bash_profile:
      export QUEX_PATH="#{libexec}"
    EOS
  end
end
