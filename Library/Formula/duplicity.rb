require 'formula'

class Duplicity < Formula
  url 'http://launchpad.net/duplicity/0.6-series/0.6.15/+download/duplicity-0.6.15.tar.gz'
  homepage 'http://www.nongnu.org/duplicity/'
  md5 '88f3c990f41fde86cd7d5af5a1bc7b81'

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
