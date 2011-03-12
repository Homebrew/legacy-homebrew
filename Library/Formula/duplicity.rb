require 'formula'

class Duplicity < Formula
  url 'http://code.launchpad.net/duplicity/0.6-series/0.6.12/+download/duplicity-0.6.12.tar.gz'
  homepage 'http://www.nongnu.org/duplicity/'
  md5 '9b84c984054550bbb2ba29b553567b7b'

  depends_on 'librsync'
  depends_on 'gnupg'

  def install
    ENV.universal_binary
    # Install mostly into libexec
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--install-purelib=#{libexec}",
                     "--install-platlib=#{libexec}"

    # Shift files around to avoid needing a PYTHONPATH
    system "mv #{bin}/duplicity #{bin}/duplicity.py"
    system "mv #{bin}/* #{libexec}"
    # Symlink the executables
    ln_s "#{libexec}/duplicity.py", "#{bin}/duplicity"
    ln_s "#{libexec}/rdiffdir", "#{bin}/rdiffdir"
  end
end
