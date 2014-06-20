require 'formula'

class CssCrush < Formula
  homepage 'http://the-echoplex.net/csscrush'
  url 'https://github.com/peteboere/css-crush/archive/v2.1.0.tar.gz'
  sha1 '3285917dce69420e2822c59e5c25401aaaa5ea64'

  def install
    libexec.install Dir['*']
    (bin+'csscrush').write <<-EOS.undent
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

    output = `#{bin}/csscrush #{path}`.strip
    assert_equal "p{color:#123456}", output
    assert_equal 0, $?.exitstatus
  end
end
