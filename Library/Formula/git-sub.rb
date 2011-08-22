require 'formula'

class GitSub < Formula
  url 'https://github.com/gosuri/git-sub/tarball/0.0.3'
  homepage 'https://github.com/gosuri/git-sub'
  md5 '33bc0d0017de284ccb85f775649a0a90'

  # depends_on 'cmake'

  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
