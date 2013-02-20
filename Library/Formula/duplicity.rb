require 'formula'

class Duplicity < Formula
  homepage 'http://www.nongnu.org/duplicity/'
  url 'http://code.launchpad.net/duplicity/0.6-series/0.6.21/+download/duplicity-0.6.21.tar.gz'
  sha1 '8594666f5312a7b367ab80b979d70a5c45f1145b'

  depends_on 'librsync'
  depends_on 'gnupg'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    # Install mostly into libexec
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--install-lib=#{libexec}",
                     "--install-scripts=#{bin}"

    # Shift files around to avoid needing a PYTHONPATH
    mv bin+'duplicity', bin+'duplicity.py'
    mv Dir[bin+'*'], libexec

    bin.install_symlink "#{libexec}/duplicity.py" => "duplicity"
    bin.install_symlink "#{libexec}/rdiffdir"
  end
end
