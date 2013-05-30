require 'formula'

class PerlBuild < Formula
  homepage 'https://github.com/tokuhirom/Perl-Build'
  url 'https://github.com/tokuhirom/Perl-Build/archive/1.02.tar.gz'
  sha1 '30043e08e1bebbf9b41341bae816e7957d6167f3'

  head 'https://github.com/tokuhirom/perl-build.git'

  def install
    bin.install "perl-build", "bin/perl-install", "bin/perl-uninstall"
  end
end
