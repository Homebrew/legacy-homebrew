require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20131222.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20131222.tar.bz2'
  sha256 '6772be4d236de1696c1d7f84eee00f36d0a69da28c845c8730c38816c9eaef21'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
