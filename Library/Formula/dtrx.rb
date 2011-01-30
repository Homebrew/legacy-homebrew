require 'formula'

class Dtrx <Formula
  url 'http://brettcsmith.org/2007/dtrx/dtrx-7.0.tar.gz'
  homepage 'http://brettcsmith.org/2007/dtrx/'
  md5 '8297bd906088aedee840a32450efb1a2'

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end
