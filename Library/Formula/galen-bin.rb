class GalenBin < Formula
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-1.4.10/galen-bin-1.4.10.zip"
  sha1 "237896138a244d1a168a3220d07edd88f6f39da9"

  depends_on :java => "1.6"

  def galen_wrapper; <<-EOS.undent
    #!/bin/sh
    set -e
    java -cp "#{libexec}/galen.jar:lib/*:libs/*" net.mindengine.galen.GalenMain "$@"
    EOS
  end

  def install
    libexec.install "galen.jar"
    (bin/"galen").write(galen_wrapper)
  end

  test do
    (testpath/"homepage.spec").write <<-EOS.undent
      ==================================================
      header              id      header
      ==================================================

      header
          height: 100px
    EOS

    (testpath/"my.test").write <<-EOS.undent
      Homepage in local Firefox browser
          selenium firefox http://samples.galenframework.com/tutorial1/tutorial1.html 640x480
              check #{testpath}/homepage.spec
    EOS

    output = shell_output("#{bin}/galen test #{testpath}/my.test")
    # print output
    assert output.include?("Status: PASS")
  end
end
