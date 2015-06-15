class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://raw.githubusercontent.com/android/tools_repo/v1.12.21/repo"
  version "1.21"
  sha1 "9421408dba2d80e3c73910567f70f2e0c91dab2f"
  revision 1

  def install
    bin.install "repo"
  end
end
