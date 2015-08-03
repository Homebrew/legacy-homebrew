class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "http://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v2.3.0.tar.gz"
  sha256 "0ddc0862f2588ff59fdf8bf56507cf4232165137af63cf9746efe97f2b256242"

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
