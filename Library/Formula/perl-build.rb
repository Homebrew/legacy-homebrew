require 'formula'

class PerlBuild < Formula
  homepage 'https://github.com/tokuhirom/Perl-Build'
  url 'https://github.com/tokuhirom/Perl-Build/archive/1.04.tar.gz'
  sha1 '1adad66a7d18f009e77674565ee57fb34194914a'

  head 'https://github.com/tokuhirom/perl-build.git'

  def install
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end
end
