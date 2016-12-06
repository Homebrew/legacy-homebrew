require 'formula'

class GitUrlSub < Formula
  version   '1.0.1'
  url       'https://github.com/gosuri/git-url-sub/tarball/1.0.1'
  homepage  'http://gosuri.github.com/git-url-sub'
  md5       '9b10177a276ed139b4aaf24359fe0d2f'

  def install
    system "make install PREFIX=#{prefix}"
  end

end
