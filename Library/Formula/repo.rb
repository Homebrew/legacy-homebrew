require 'formula'

class Repo < Formula
  homepage 'http://source.android.com/source/git-repo.html'
  url 'http://git-repo.googlecode.com/files/repo-1.17'
  sha1 'ddd79b6d5a7807e911b524cb223bc3544b661c28'
  version '1.17'

  def install
    bin.install "repo-#{version}" => 'repo'
  end
end
