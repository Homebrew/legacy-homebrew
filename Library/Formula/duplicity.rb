require 'formula'

class Duplicity < Formula
  homepage 'http://www.nongnu.org/duplicity/'
  url 'http://code.launchpad.net/duplicity/0.6-series/0.6.20/+download/duplicity-0.6.20.tar.gz'
  sha1 '5781fa325c846fd8453c68a33ede3c7a0d105a80'

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
    mv bin+'duplicity', bin+'duplicity.py'
    mv Dir[bin+'*'], libexec

    bin.install_symlink "#{libexec}/duplicity.py" => "duplicity"
    bin.install_symlink "#{libexec}/rdiffdir"
  end
end
