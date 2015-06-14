class CssCrush < Formula
  desc "An extensible PHP based CSS preprocessor"
  homepage "http://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v2.3.0.tar.gz"
  sha1 "1141311ad12e4472d5ec2fddcefec42d98655725"

  def install
    libexec.install Dir["*"]
    (bin+"csscrush").write <<-EOS.undent
      #!/bin/sh
      php "#{libexec}/cli.php" "$@"
    EOS
  end

  test do
    path = testpath/"test.crush"
    path.write <<-EOS.undent
      @define foo #123456;
      p { color: $(foo); }
    EOS

    assert_equal "p{color:#123456}", shell_output("#{bin}/csscrush #{path}").strip
  end
end
