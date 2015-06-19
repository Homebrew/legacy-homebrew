class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "http://abcl.org"
  url "http://abcl.org/releases/1.3.2/abcl-bin-1.3.2.tar.gz"
  sha256 "01105fe25c51873b71ffd6f0ba2d9b2688741ed96ff60c1950c0e62f9d84a785"

  bottle do
    cellar :any
    sha256 "deede4e4929c5b566d4cd9a32a305bc42ba614fb49f7e267c471e752b3a373c5" => :yosemite
    sha256 "0cd7402db8c335a5a8e93ee5d78d31f365bf786baaf98a7382b1c902a53472cd" => :mavericks
    sha256 "32ee139646ce32e020ca9d1d8026119d5cc4f4957976a0aacd6edbd3fae6e3e0" => :mountain_lion
  end

  depends_on :java => "1.5+"
  depends_on "rlwrap"

  def install
    libexec.install "abcl.jar", "abcl-contrib.jar"
    (bin+"abcl").write <<-EOS.undent
      #!/bin/sh
      rlwrap java -jar "#{libexec}/abcl.jar" "$@"
    EOS
  end

  test do
    assert_match "42", pipe_output("#{bin}/abcl", "(+ 1 1 40)")
  end
end
