class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      :tag => "v1.12.32",
      :revision => "745b4ad660f8050045b521c4e15b7d3ac0b3d70e"
  version "1.22"

  bottle :unneeded

  def install
    bin.install "repo"
  end
end
