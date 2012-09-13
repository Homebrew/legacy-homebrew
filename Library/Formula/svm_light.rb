require 'formula'

class SvmLight < Formula
  homepage 'http://svmlight.joachims.org'
  url 'http://download.joachims.org/svm_light/current/svm_light.tar.gz'
  sha1 '3b0f843e6f8f4f168d3e33ab957f22c56ccadd86'

  def install
    system "make"
    bin.install "svm_learn"    
    bin.install "svm_classify"
  end
end
