require 'formula'

class Duplicity < Formula
  homepage 'http://www.nongnu.org/duplicity/'
  url 'https://launchpad.net/duplicity/0.6-series/0.6.18/+download/duplicity-0.6.18.tar.gz'
  md5 '66b5e64de43e09d3c3ff9890faf9de07'

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
