require 'formula'

class Cloc < ScriptFileFormula
  url 'http://downloads.sourceforge.net/project/cloc/cloc/v1.53/cloc-1.53.pl'
  md5 '47f13134a3b2b0c18dede35132cc15b4'
  version '1.53'
  homepage 'http://cloc.sourceforge.net/'

  def install
    bin.install 'cloc-1.53.pl' => 'cloc'
  end
end
