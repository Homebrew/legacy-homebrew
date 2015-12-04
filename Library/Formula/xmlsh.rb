class Xmlsh < Formula
  desc "XML shell"
  homepage "http://www.xmlsh.org"
  url "https://downloads.sourceforge.net/project/xmlsh/xmlsh/1.2.5/xmlsh_1_2_5.zip"
  sha256 "489df45f19a6bb586fdb5abd1f8ba9397048597895cb25def747b0118b02b1c8"

  bottle :unneeded

  def install
    rm_rf %w[win32 cygwin]
    libexec.install Dir["*"]
    chmod 0755, "#{libexec}/unix/xmlsh"
    (bin/"xmlsh").write <<-EOS.undent
      #!/bin/bash
      export XMLSH=#{libexec}
      exec #{libexec}/unix/xmlsh "$@"
    EOS
  end

  test do
    output = shell_output("#{bin}/xmlsh -c 'x=<[<foo bar=\"baz\" />]> && echo <[$x/@bar]>'")
    assert_equal "baz\n", output
  end
end
