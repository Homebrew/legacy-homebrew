require 'formula'

class Cloc < ScriptFileFormula
  url 'http://downloads.sourceforge.net/project/cloc/cloc/v1.55/cloc-1.55.pl'
  md5 '19ab5852617e89d853793a693eb5e510'
  homepage 'http://cloc.sourceforge.net/'

  def install
    bin.install 'cloc-1.55.pl' => 'cloc'
  end
end
