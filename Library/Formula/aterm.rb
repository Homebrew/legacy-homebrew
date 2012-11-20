require 'formula'

class Aterm < Formula
  homepage 'http://strategoxt.org/Tools/ATermFormat'
  url 'http://www.meta-environment.org/releases/aterm-2.8.tar.gz'
  sha1 'c9a69db0d0ac58970568f6b46ce96af457d84bcc'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV.j1 # Parallel builds don't work
    system "make install"
  end
end
