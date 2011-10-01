require 'formula'

class SvmLight < Formula
  url 'http://osmot.cs.cornell.edu/svm_light/v6.02/svm_light.tar.gz'
  version '6.02'
  homepage 'http://svmlight.joachims.org/'
  md5 '59768adde96737b1ecef123bc3a612ce'

  def install
    system "make"
    bin.install ['svm_learn', 'svm_classify']
  end
end
