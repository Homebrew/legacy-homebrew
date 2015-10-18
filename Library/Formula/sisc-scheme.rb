class SiscScheme < Formula
  desc "Extensive Java based Scheme interpreter"
  homepage "http://sisc-scheme.org/"
  url "https://downloads.sourceforge.net/project/sisc/SISC%20Lite/1.16.6/sisc-lite-1.16.6.tar.gz"
  sha256 "7a2f1ee46915ef885282f6df65f481b734db12cfd97c22d17b6c00df3117eea8"

  def install
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"sisc").write <<-EOS.undent
      #!/bin/sh
      SISC_HOME=#{libexec}
      exec #{libexec}/sisc "$@"
    EOS
  end
end
