class GitMultipush < Formula
  desc "Push a branch to multiple remotes in one command"
  homepage "https://github.com/gavinbeatty/git-multipush"
  url "https://github.com/gavinbeatty/git-multipush/archive/git-multipush-v2.3.tar.gz"
  sha256 "883e4e88787a71c84ed94f6c3175fab587f0b15980fd0d74b839474295638081"

  head "https://github.com/gavinbeatty/git-multipush.git"

  devel do
    url "https://github.com/gavinbeatty/git-multipush/archive/git-multipush-v2.4.rc2.tar.gz"
    sha256 "999d9304f322c1b97d150c96be64ecde30980f97eaaa9d66f365b8b11894c46d"
    version "2.4-rc2"
  end

  depends_on "asciidoc" => :build

  def install
    unless build.head?
      # This is inferred with git-describe but we only have a tarball here
      ENV["VERSION"] = version.to_s
      ENV["PROJECT_VERSION_VAR"] = "VERSION"
    end

    system "make" if build.head?
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "git", "init"
    assert_equal "git push", shell_output("git multipush -n 2>&1").chomp
  end
end
