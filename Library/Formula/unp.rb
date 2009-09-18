require 'brewkit'

class Unp <Formula
  @url='http://ftp.de.debian.org/debian/pool/main/u/unp/unp_1.0.11.tar.gz'
  @homepage='http://packages.debian.org/de/etch/unp'
  @md5='ecea662bd7e7efe7f7e2213bf21d9646'

  depends_on 'p7zip'

  def install
    bin.install %w[unp ucat]
    man1.install "debian/unp.1"

    FileUtils.mv 'debian/README.debian', 'README'
    FileUtils.mv 'debian/copyright', 'COPYING'
    FileUtils.mv 'debian/changelog', 'ChangeLog'
  end
end
