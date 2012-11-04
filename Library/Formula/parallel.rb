require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20121022.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20121022.tar.bz2'
  sha256 '13626899b50f884d635e0bd21684e87e51d0f235e760f11b8df4a605e0fa03c8'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
