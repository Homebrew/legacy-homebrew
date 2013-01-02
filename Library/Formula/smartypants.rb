require 'formula'

class Smartypants < Formula
  url 'http://daringfireball.net/projects/downloads/SmartyPants_1.5.1.zip'
  sha1 '339a493f89cfee1e9f051bb1b39f9dcae4c595ca'
  homepage 'http://daringfireball.net/projects/smartypants/'

  def install
    bin.install 'SmartyPants.pl' => 'smartypants'
  end
end
