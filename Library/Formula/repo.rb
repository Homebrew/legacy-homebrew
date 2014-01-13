require 'formula'

class Repo < Formula
  homepage 'http://source.android.com/source/git-repo.html'
  url 'https://raw.github.com/android/tools_repo/v1.12.4/repo'
  version '1.20'
  sha1 'e197cb48ff4ddda4d11f23940d316e323b29671c'

  def install
    bin.install 'repo'
  end
end
