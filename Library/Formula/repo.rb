require 'formula'

class Repo < Formula
  homepage 'http://source.android.com/source/git-repo.html'
  url 'http://git-repo.googlecode.com/files/repo-1.15'
  sha1 '4c06bc2d1466c638f4594d492fd18fd2da38bf5f'
  version '1.15'

  def install
    bin.install "repo-#{version}" => 'repo'
  end
end
