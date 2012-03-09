require 'formula'

class Sl < Formula
  homepage 'http://practicalthought.com/sl/'
  url 'http://practicalthought.com/sl/sl-1.1.zip'
  md5 '2593bc2ec3014d2fc9e2d3ea1b7a3255'

  def install
    bin.install('sl')
  end
end
