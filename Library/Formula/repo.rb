require 'formula'

class Repo < Formula
  homepage 'http://source.android.com/source/git-repo.html'
  url 'https://raw.githubusercontent.com/android/tools_repo/v1.12.13/repo'
  version '1.21'
  sha1 'b8bd1804f432ecf1bab730949c82b93b0fc5fede'

  def install
    bin.install 'repo'
  end
end
