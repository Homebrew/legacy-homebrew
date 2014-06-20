require 'formula'

class PerlBuild < Formula
  homepage 'https://github.com/tokuhirom/Perl-Build'
  url 'https://github.com/tokuhirom/Perl-Build/archive/1.06.tar.gz'
  sha1 '59d82893c2b0272137b6d5614a5966df3bdd6a4b'

  head 'https://github.com/tokuhirom/perl-build.git'

  def install
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end
end
