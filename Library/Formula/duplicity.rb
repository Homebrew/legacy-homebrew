require 'formula'

class Duplicity < Formula
  url 'http://code.launchpad.net/duplicity/0.6-series/0.6.13/+download/duplicity-0.6.13.tar.gz'
  homepage 'http://www.nongnu.org/duplicity/'
  md5 'b3d627f35fc527b00121925840d5cca7'

  depends_on 'librsync'
  depends_on 'gnupg'

  def install
    ENV.universal_binary
    # Install mostly into libexec
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--install-purelib=#{libexec}",
                     "--install-platlib=#{libexec}",
                     "--install-scripts=#{bin}"

    # Shift files around to avoid needing a PYTHONPATH
    system "mv #{bin}/duplicity #{bin}/duplicity.py"
    system "mv #{bin}/* #{libexec}"
    # Symlink the executables
    ln_s "#{libexec}/duplicity.py", "#{bin}/duplicity"
    ln_s "#{libexec}/rdiffdir", "#{bin}/rdiffdir"
  end
end
