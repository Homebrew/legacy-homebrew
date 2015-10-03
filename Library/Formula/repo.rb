class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://raw.githubusercontent.com/android/tools_repo/v1.12.21/repo"
  version "1.21"
  sha256 "44d1ac8b948e6154a495469dad05870dc6182712c0610da8d255b5471dd5bcb9"
  revision 1

  def install
    bin.install "repo"
  end
end
