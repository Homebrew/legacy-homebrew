require 'formula'

class CssCrush < Formula
  homepage 'http://the-echoplex.net/csscrush'
  url 'https://github.com/peteboere/css-crush/archive/v1.11.tar.gz'
  sha1 'f67697f62c4ca3608eb1d52955496022c4af37fa'

  def install
    libexec.install Dir['*']
    (bin+'csscrush').write <<-EOS.undent
      #!/bin/sh
      php "#{libexec}/cli.php" "$@"
    EOS
  end
end
