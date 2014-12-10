require "formula"

class CssCrush < Formula
  homepage "http://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v2.2.1.tar.gz"
  sha1 "39c721af2765f36d4a2990fe365fb18c3ee41485"

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
