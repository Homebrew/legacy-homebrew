require 'formula'

class SlLs < Formula
  homepage 'http://practicalthought.com/sl/'
  url 'http://practicalthought.com/sl/sl'
  md5 'ed4c22a531e957c95df5f41206d6ed2f'
  version '1.1.2'

  def install
    bin.install 'sl'
  end

end
