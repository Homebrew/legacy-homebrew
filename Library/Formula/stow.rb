require 'formula'

class Stow < Formula
  homepage 'http://www.gnu.org/software/stow/'
  url 'http://ftpmirror.gnu.org/stow/stow-2.2.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/stow/stow-2.2.0.tar.gz'
  sha1 'b95091be6ebbbac8c5e5112d6d063299c5eefff2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
