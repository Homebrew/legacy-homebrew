require 'formula'

class Duplicity < Formula
  homepage 'http://www.nongnu.org/duplicity/'
  url 'http://code.launchpad.net/duplicity/0.6-series/0.6.22/+download/duplicity-0.6.22.tar.gz'
  sha1 'afa144f444148b67d7649b32b80170d917743783'

  depends_on :python
  depends_on 'librsync'
  depends_on 'gnupg'

  option :universal

  def install
    python do
      ENV.universal_binary if build.universal?
      # Install mostly into libexec
      system python, "setup.py", "install", "--prefix=#{prefix}"
    end
  end
end
