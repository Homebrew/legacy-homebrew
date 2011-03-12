require 'formula'

class Unp < Formula
  url 'http://mirrors.kernel.org/debian/pool/main/u/unp/unp_1.0.15.tar.gz'
  homepage 'http://packages.debian.org/source/stable/unp'
  md5 'bcf45819ac76093bba7b4a3f5b3a4bff'

  depends_on 'p7zip'

  def install
    bin.install %w[unp ucat]
    man1.install "debian/unp.1"

    mv 'debian/README.Debian', 'README'
    mv 'debian/copyright', 'COPYING'
    mv 'debian/changelog', 'ChangeLog'
  end
end
