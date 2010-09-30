require 'formula'

class Unp <Formula
  url 'http://mirrors.kernel.org/debian/pool/main/u/unp/unp_1.0.11.tar.gz'
  homepage 'http://packages.debian.org/de/etch/unp'
  md5 'ecea662bd7e7efe7f7e2213bf21d9646'

  depends_on 'p7zip'

  def install
    bin.install %w[unp ucat]
    man1.install "debian/unp.1"

    mv 'debian/README.Debian', 'README'
    mv 'debian/copyright', 'COPYING'
    mv 'debian/changelog', 'ChangeLog'
  end
end
