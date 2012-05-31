require 'formula'

class Repo < Formula
  homepage 'http://source.android.com/source/git-repo.html'
  url 'http://git-repo.googlecode.com/files/repo-1.16'
  sha1 'f3bfa7fd2d0a44aa40579bb0242cc20df37b5e17'
  version '1.16'

  def install
    bin.install "repo-#{version}" => 'repo'
  end
end
