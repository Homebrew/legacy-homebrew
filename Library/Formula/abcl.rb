class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "http://abcl.org"
  url "http://abcl.org/releases/1.3.3/abcl-bin-1.3.3.tar.gz"
  sha256 "01e1d05b14eca802c727dea8be9350e22dfddf8a8637ec9fbd8323c4f7f2a954"

  bottle :unneeded

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
