require 'formula'

class Cloc < ScriptFileFormula
  url 'http://downloads.sourceforge.net/project/cloc/cloc/v1.56/cloc-1.56.pl'
  md5 '2739127ce5398fa627b50e54ea3dcbb6'
  homepage 'http://cloc.sourceforge.net/'

  def install
    bin.install 'cloc-1.56.pl' => 'cloc'
  end
end
