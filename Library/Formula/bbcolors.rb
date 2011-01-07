require 'formula'

class Bbcolors <Formula
  url 'http://daringfireball.net/projects/downloads/bbcolors_1.0.1.zip'
  homepage 'http://daringfireball.net/projects/bbcolors/'
  md5 '43ae9c44f0a423fcf3e6a21ed3afaec4'

  def install
    bin.install "bbcolors"
  end
end
