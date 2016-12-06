require 'formula'

class Lenskit < Formula
  homepage 'http://lenskit.grouplens.org/'
  url 'http://lenskit.grouplens.org/downloads/lenskit-2.0.tar.gz'
  sha1 '3fb5364bd1324b11eea075c573809fdce6b7ac30'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Mark the eval script as executable
    chmod 0744, Dir["bin/*"]

    # Install the lenskit contents
    bin.install Dir['bin/*']
    lib.install Dir['lib/*']

    # Symlink the Binary
    bin.install_symlink Dir["bin/lenskit-eval"]
  end
end