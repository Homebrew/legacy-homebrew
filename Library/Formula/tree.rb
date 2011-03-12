require 'formula'

class Tree < Formula
  url 'ftp://mama.indstate.edu/linux/tree/tree-1.5.3.tgz'
  homepage 'http://mama.indstate.edu/users/ice/tree/'
  md5 'c07ce9065667a23f27aca4de8ecccb10'

  def install
    system "#{ENV.cc} #{ENV.cflags} -o tree tree.c strverscmp.c"

    bin.install "tree"
    man1.install "man/tree.1"
  end
end
