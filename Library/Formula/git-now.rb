class GitNow < Formula
  desc "Light, temporary commits for git"
  homepage "https://github.com/iwata/git-now"
  url "https://github.com/iwata/git-now.git",
      :tag => "v0.1.1.0",
      :revision => "a07a05893b9ddf784833b3d4b410c843633d0f71"

  head "https://github.com/iwata/git-now.git"

  depends_on "gnu-getopt"

  def install
    system "make", "prefix=#{libexec}", "install"

    (bin/"git-now").write <<-EOS.undent
      #!/bin/sh
      PATH=#{Formula["gnu-getopt"].opt_bin}:$PATH #{libexec}/bin/git-now "$@"
    EOS

    zsh_completion.install "etc/_git-now"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    touch "file1"
    system "git", "init"
    system "git", "add", "file1"
    system bin/"git-now"
    assert_match "from now", shell_output("git log -1")
  end
end
