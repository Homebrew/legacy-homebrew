require 'formula'

class Whereami <Formula
  url 'https://github.com/yikulju/whereami/raw/master/build/Release/whereami', :using => :nounzip
  homepage 'https://github.com/yikulju/whereami'
  md5 'ab41fdba223f971be13b1845122353cb'
  version '1.0'

  def install
    bin.install ['whereami']
  end
end
