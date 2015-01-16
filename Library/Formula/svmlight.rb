class Svmlight < Formula
  homepage "http://svmlight.joachims.org/"
  url "http://download.joachims.org/svm_light/current/svm_light.tar.gz"
  version "6.02"
  sha1 "3b0f843e6f8f4f168d3e33ab957f22c56ccadd86"

  def install
    system "make", "all"
    bin.install "svm_learn"
    bin.install "svm_classify"
  end

  test do
    # write some data for training and testing
    (testpath/"example_file").write("3 qid:1 1:0.53 2:0.12\n2 qid:1 1:0.13 2:0.1\n7 qid:2 1:0.87 2:0.12")
    system "#{bin}/svm_learn", testpath/"example_file", testpath/"model_file"
    # we're testing on the same file used for training
    system "#{bin}/svm_classify", testpath/"example_file", testpath/"model_file", testpath/"predictions"
  end
end
