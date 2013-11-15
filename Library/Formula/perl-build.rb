require 'formula'

class PerlBuild < Formula
  homepage 'https://github.com/tokuhirom/Perl-Build'
  url 'https://github.com/tokuhirom/Perl-Build/archive/1.05.tar.gz'
  sha1 '0ac64b152c6de9b4917ae0a5877efaad0160af48'

  head 'https://github.com/tokuhirom/perl-build.git'

  def install
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end
end
