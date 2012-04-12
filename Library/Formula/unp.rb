require 'formula'

class Unp < Formula
  homepage 'http://packages.debian.org/source/stable/unp'
  url 'http://mirrors.kernel.org/debian/pool/main/u/unp/unp_2.0~pre7.tar.bz2'
  mirror 'http://ftp.us.debian.org/debian/pool/main/u/unp/unp_2.0~pre7.tar.bz2'
  sha1 '8e26bba069b5015425c0684575e84ff131c09756'
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
