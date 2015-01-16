class Svmrank < Formula
  homepage "http://www.cs.cornell.edu/people/tj/svm_light/svm_rank.html"
  url "http://download.joachims.org/svm_rank/current/svm_rank.tar.gz"
  version "1.00"
  sha1 "0f81e563aed064fbca0477d8f8a1d640b1b9c2f9"

  def install
    system "make", "all"
    bin.install "svm_rank_classify"
    bin.install "svm_rank_learn"
  end

  test do
    # write some data for training and testing
    (testpath/"example_file").write("3 qid:1 1:0.53 2:0.12\n2 qid:1 1:0.13 2:0.1\n7 qid:2 1:0.87 2:0.12")
    system "#{bin}/svm_rank_learn", "-c", "20.0", testpath/"example_file", testpath/"model_file"
    # we're testing on the same file used for training
    system "#{bin}/svm_rank_classify", testpath/"example_file", testpath/"model_file", testpath/"predictions"
  end
end
