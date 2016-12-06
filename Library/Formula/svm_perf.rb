require 'formula'

class SvmPerf < Formula
  homepage 'http://www.cs.cornell.edu/people/tj/svm_light/svm_perf.html'
  url 'http://download.joachims.org/svm_perf/current/svm_perf.tar.gz'
  sha1 '35a5501473fe135104bc88f3897ef34e1731e0e8'

  def install
    system "make"
    bin.install "svm_perf_learn"    
    bin.install "svm_perf_classify"
  end
end
