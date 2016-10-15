class GitBigPicture < Formula
  homepage "https://github.com/esc/git-big-picture"
  url "https://github.com/esc/git-big-picture/archive/v0.9.0.tar.gz"
  sha1 "d0265f32bcb9e6c1b7991e470e621c1931ee6790"

  depends_on "graphviz" => :recommended

  def install
    bin.install "git-big-picture"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "A"
    system "git", "commit", "--allow-empty", "-m", "B"
    system "git", "branch", "b"
    system "git", "commit", "--allow-empty", "-m", "C"
    system "git", "branch", "c"

    system "git-big-picture", "-V", "-o", "tree.png"
  end
end
