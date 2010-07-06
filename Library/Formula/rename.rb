require 'formula'

class Rename <Formula
  url 'http://plasmasturm.org/code/rename/rename'
  version '0.1.3'
  homepage 'http://plasmasturm.org/code/rename'
  md5 'ce931227630a44d5d4ca4234a1fb8e63'

  def download_strategy
    NoUnzipCurlDownloadStrategy
  end

  def install
    system 'pod2man', 'rename', 'rename.1'
    bin.install 'rename'
    man1.install 'rename.1'
  end
end
