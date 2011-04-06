require 'formula'

class Sparse < Formula
  url 'http://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.4.3.tar.bz2'
  homepage 'https://sparse.wiki.kernel.org/index.php/Main_Page'
  md5 'a5c0b07bd00ad5ea292f804d7af1adbc'

  def install
    prefix.mkpath
    system "make", "HOME=#{prefix}", "install"
  end
end
