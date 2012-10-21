require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20120822.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20120822.tar.bz2'
  sha1 '9120fe0764029bdbe5eb293a281121335aa343ff'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
