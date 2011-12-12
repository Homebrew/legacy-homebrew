require 'formula'

class Duplicity < Formula
  url 'http://launchpad.net/duplicity/0.6-series/0.6.17/+download/duplicity-0.6.17.tar.gz'
  homepage 'http://www.nongnu.org/duplicity/'
  md5 '36423ab4e3b9aa90c5c44d9fa93fba0f'

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
