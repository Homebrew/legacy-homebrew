require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20130722.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20130722.tar.bz2'
  sha256 '68185dfe3e94656c680c713f495840edf00bac0e8233e9fe1161f2ae3f99f66b'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
