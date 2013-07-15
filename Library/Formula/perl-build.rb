require 'formula'

class PerlBuild < Formula
  homepage 'https://github.com/tokuhirom/Perl-Build'
  url 'https://github.com/tokuhirom/Perl-Build/archive/1.03.tar.gz'
  sha1 'dda816ad6445d82b4be144dc426d33853a8b5344'

  head 'https://github.com/tokuhirom/perl-build.git'

  def install
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end
end
