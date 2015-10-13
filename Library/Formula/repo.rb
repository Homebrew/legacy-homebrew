class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://raw.githubusercontent.com/android/tools_repo/v1.12.32/repo"
  version "1.22"
  sha256 "9907c36d63cf5222d73ab270fee5249dc84f6b4580cda03ddd7ac309f11b289e"

  def install
    bin.install "repo"
  end
end
