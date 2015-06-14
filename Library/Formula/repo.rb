require 'formula'

class Repo < Formula
  desc "Repository tool for Android development"
  homepage 'http://source.android.com/source/git-repo.html'
  url 'https://raw.githubusercontent.com/android/tools_repo/v1.12.21/repo'
  version '1.21'
  revision 1
  sha1 '9421408dba2d80e3c73910567f70f2e0c91dab2f'

  def install
    bin.install 'repo'
  end
end
