class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "http://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v2.4.0.tar.gz"
  sha256 "75c8d868adf5a537a47fedff28c53fe4e6764264239573a858a0048036280d6c"
  head "https://github.com/peteboere/css-crush.git"

  def install
    libexec.install Dir["*"]
    (bin+"csscrush").write <<-EOS.undent
      #!/bin/sh
      php "#{libexec}/cli.php" "$@"
    EOS
  end

  test do
    (testpath/"test.crush").write <<-EOS.undent
      @define foo #123456;
      p { color: $(foo); }
    EOS

    assert_equal "p{color:#123456}", shell_output("#{bin}/csscrush #{testpath}/test.crush").strip
  end
end
