require 'formula'

class Rfcmarkup <Formula
  url 'http://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.85.tgz'
  homepage 'http://tools.ietf.org/tools/rfcmarkup/'
  md5 '39b0a71dd7da79c781093fe48d290de1'

  def install
    inreplace "rfcmarkup", "/usr/local/bin/python", "/usr/bin/python"    
    bin.install "rfcmarkup"
    doc.install %w(changelog copyright todo)
  end
end
