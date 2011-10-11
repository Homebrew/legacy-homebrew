require 'formula'

class Iprover < Formula
  url 'http://iprover.googlecode.com/files/iprover_v0.8.1.tar.gz'
  homepage 'http://www.cs.man.ac.uk/~korovink/iprover/'
  md5 '93ca7498eefdc9e005e07714c9fe38ee'

  depends_on 'objective-caml'

  def install
    system "./configure"
    ENV.deparallelize
    ENV.no_optimization
    system "make"
    bin.install "iproveropt"
    share.install "problem.p"
  end

  def test
    system "iproveropt", "#{share}/problem.p"
  end
end
