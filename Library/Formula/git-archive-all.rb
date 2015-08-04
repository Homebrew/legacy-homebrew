class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.11.tar.gz"
  sha256 "9d7c71604212fcf1eaf1df86d4ee52a9ec08449aecfc616eb3cf08cc5729b1cf"

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
