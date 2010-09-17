require 'formula'

class Ttytter <ScriptFileFormula
  url 'http://www.floodgap.com/software/ttytter/dist1/1.1.05.txt'
  homepage 'http://www.floodgap.com/software/ttytter/'
  md5 '354aa87ed02105b800a8dcb9e658f8dd'

  def install
    bin.install '1.1.05.txt' => 'ttytter'
  end
end
