require 'formula'

class Repo < Formula
  homepage 'http://source.android.com/source/git-repo.html'
  url 'http://git-repo.googlecode.com/files/repo-1.18'
  version '1.18'
  sha1 '562a9091b4529d7a2afb87131e548a9d12241da5'

  def install
    bin.install "repo-#{version}" => 'repo'
  end
end
