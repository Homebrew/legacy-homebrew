require 'formula'

class Xlsperl <Formula
  url 'http://perl.jonallen.info/attachment/33/XLSperl-0.7-OSX-Intel.tar.gz'
  homepage 'http://perl.jonallen.info/projects/xlsperl'
  md5 '4c72efe06c34163a66876657e874ec9d'
  version '0.7'

  # depends_on 'cmake'

  def install
    bin.install ['XLSperl']
  end
end
