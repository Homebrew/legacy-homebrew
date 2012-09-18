require 'formula'

class Cloc < ScriptFileFormula
  url 'http://downloads.sourceforge.net/project/cloc/cloc/v1.56/cloc-1.56.pl'
  sha1 '238ea26eccfc574c27aa90ee17741f363959be3f'
  homepage 'http://cloc.sourceforge.net/'

  def install
    bin.install 'cloc-1.56.pl' => 'cloc'
  end
end
