require 'formula'

class Unp < Formula
  homepage 'http://packages.debian.org/source/stable/unp'
  url 'http://ftp.us.debian.org/debian/pool/main/u/unp/unp_2.0~pre7%2bnmu1.tar.bz2'
  mirror 'http://ftp.us.debian.org/debian/pool/main/u/unp/unp_2.0~pre7%2bnmu1.tar.bz2'
  sha1 'b91f4cbc4720b3aace147652ac2043cf74668244'
  version '2.0-pre7'

  depends_on 'p7zip'

  def install
    bin.install %w[unp ucat]
    man1.install "debian/unp.1"
    (prefix+'etc/bash_completion.d').install 'bash_completion.d/unp'
    %w[ COPYING CHANGELOG ].each { |f| rm f }
    mv 'debian/README.Debian', 'README'
    mv 'debian/copyright', 'COPYING'
    mv 'debian/changelog', 'ChangeLog'
  end
end
