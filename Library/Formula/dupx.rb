require 'formula'

class Dupx < Formula
  homepage 'http://www.isi.edu/~yuri/dupx/'
  url 'http://www.isi.edu/~yuri/dupx/dupx-0.1.tar.gz'
  sha1 '69cac2bacc9aefff59e84d5bfd053f01c1bc7551'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
