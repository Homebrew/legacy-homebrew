class Abcl < Formula
  homepage "http://abcl.org"
  url "http://abcl.org/releases/1.3.2/abcl-bin-1.3.2.tar.gz"
  sha256 "01105fe25c51873b71ffd6f0ba2d9b2688741ed96ff60c1950c0e62f9d84a785"

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
