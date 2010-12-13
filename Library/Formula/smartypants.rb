require 'formula'

class Smartypants <Formula
  url 'http://daringfireball.net/projects/downloads/SmartyPants_1.5.1.zip'
  md5 '30114747ef913ddd4b6931b6583a42e3'
  homepage 'http://daringfireball.net/projects/smartypants/'

  def install
    bin.install 'SmartyPants.pl' => 'smartypants'
  end
end
