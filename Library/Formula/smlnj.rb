require 'formula'

class Smlnj <Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.72/config.tgz'
  homepage 'http://www.smlnj.org/'
  md5 '97503a4e749a5e72ff975f3883688105'
  version '110.72'

  def install
    ENV.deparallelize
    # smlnj is much easier to build if we do so in the directory where it
    # will be installed.  Thus, we're moving it to the prefix to be built
    # there.
    Dir.chdir '..'
    prefix.install 'config'
    Dir.chdir prefix
    File::open('config/targets', 'w') do |f|
      f << targets
    end
    system 'config/install.sh'
  end

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
end
