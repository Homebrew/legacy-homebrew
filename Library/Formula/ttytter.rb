require 'formula'

class Ttytter <ScriptFileFormula
  url 'http://www.floodgap.com/software/ttytter/dist1/1.1.03.txt'
  homepage 'http://www.floodgap.com/software/ttytter/'
  md5 'e00f3b9cac53f011c7c597af4729b0a5'

  def install
    bin.install '1.1.03.txt' => 'ttytter'
  end
end
