require 'formula'

class WbfsFile <Formula
  url 'http://cfg-loader.googlecode.com/files/wbfs_file_2.9.zip'
  homepage 'http://code.google.com/p/cfg-loader/'
  md5 'c07364893bf426bd31db7644fe9ed372'

  def install
    system "cd source && make"
    bin.install 'source/wbfs_file'
  end
end
