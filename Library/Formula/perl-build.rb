require "formula"

class PerlBuild < Formula
  homepage "https://github.com/tokuhirom/Perl-Build"
  url "https://github.com/tokuhirom/Perl-Build/archive/1.08.tar.gz"
  sha1 "98842888f8106cabf5806bddf48c0d1567a12b05"

  head "https://github.com/tokuhirom/perl-build.git"

  def install
    bin.install "perl-build", "bin/plenv-install", "bin/plenv-uninstall"
  end
end
