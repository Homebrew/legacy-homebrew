require 'formula'

class Qcl < Formula
  homepage 'http://tph.tuwien.ac.at/~oemer/qcl.html'
  url 'http://tph.tuwien.ac.at/~oemer/tgz/qcl-0.6.3.tgz'
  sha1 '16ca54239d5f742a49ba400eeb766f6267a4f13a'
  
  depends_on 'flex'
  depends_on 'readline'
  
  fails_with :clang do
    cause 'Clang does not support variable-length arrays for non-POD types.'
  end

  def install
    system "make", "CXX=#{ENV.cxx}", "QCLDIR=#{prefix}/qcllib", "PLOPT=", "PLLIB="
    bin.install 'qcl'
    prefix.install 'lib' => 'qcllib'
  end
end
