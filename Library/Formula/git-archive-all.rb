class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.12.tar.gz"
  sha256 "d17859736aa6628d21f80ce44e35cbdca495c90f5db23ebd8a8b18b3398fcf13"

  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any
    sha256 "a5e6e69398c8b03afb1cd30348535a031605a948255866f235048c2b4d9bca4f" => :yosemite
    sha256 "8b677f5b86fa1bef87aa8a0f7465bc828a47608f24e521c45eabddcf0c531a7e" => :mavericks
    sha256 "cd81704fc6ea59b93934ec7dc76301d8b4e6e6f39ea54af3cbb133ac0acefcc9" => :mountain_lion
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
