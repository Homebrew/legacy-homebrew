require 'formula'

class Smlnj <Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.72/config.tgz'
  homepage 'http://www.smlnj.org/'
  md5 '97503a4e749a5e72ff975f3883688105'
  version '110.72'

  def targets
<<-EOS
request ml-ulex
request ml-ulex-mllex-tool
request ml-lex
request ml-lex-lex-ext
request ml-yacc
request ml-yacc-grm-ext
request ml-antlr
request ml-lpt-lib
request ml-burg
request smlnj-lib
request tdp-util
request cml
request cml-lib
request mlrisc
request ckit
request heap2asm
EOS
  end

  def install
    ENV.deparallelize
    # smlnj is much easier to build if we do so in the directory where it
    # will be installed.  Thus, we're moving it to the prefix to be built
    # there.
    Dir.chdir '..'
    libexec.install 'config'
    rm (libexec+'config/targets') # Rewrite targets list
    (libexec+'config/targets').write targets
    Dir.chdir libexec
    system 'config/install.sh'
  end

  def caveats
    <<-EOS.undent
    This formula spews ML files all over lib, and puts hidden subfolders in bin.
    Because of this, we've installed it to:
      #{libexec}
    and we haven't linked it into #{HOMEBREW_PREFIX}

    You'll need to add:
      #{libexec}/bin
    to your PATH.

    Improvements are welcome.
    EOS
  end
end
