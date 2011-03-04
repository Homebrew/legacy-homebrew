require 'formula'

class Fex <Formula
  url 'http://semicomplete.googlecode.com/files/fex-1.20100416.2814.tar.gz'
  homepage 'http://www.semicomplete.com/projects/fex/'
  sha1 'b5748f6d2106633ce32409f7e3709e4c60744572'

  def install
    ENV['PREFIX'] = prefix
  	system "make install"
  end
end
