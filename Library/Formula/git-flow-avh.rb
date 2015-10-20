class GitFlowAvh < Formula
  desc "AVH edition of git-flow"
  homepage "https://github.com/petervanderdoes/gitflow-avh"
  url "https://github.com/petervanderdoes/gitflow-avh/archive/1.9.1.tar.gz"
  sha256 "7692c77744663c5243cdd390bef0a621caee92dde228b50ef97149fc1b54780d"

  head do
    url "https://github.com/petervanderdoes/gitflow-avh.git", :branch => "develop"

    resource "completion" do
      url "https://github.com/petervanderdoes/git-flow-completion.git", :branch => "develop"
    end
  end

  resource "completion" do
    url "https://github.com/petervanderdoes/git-flow-completion/archive/0.5.1.tar.gz"
    sha256 "5c8547a549dc623a8d57cfc22c3fa88588f5630da9dc6de9638e5b69da9d47d0"
  end

  depends_on "gnu-getopt"

  conflicts_with "git-flow"

  def install
    system "make", "prefix=#{libexec}", "install"
    (bin/"git-flow").write <<-EOS.undent
      #!/bin/bash
      export FLAGS_GETOPT_CMD=#{Formula["gnu-getopt"].opt_bin}/getopt
      exec "#{libexec}/bin/git-flow" "$@"
    EOS

    resource("completion").stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
    end
  end

  test do
    system "#{bin}/git-flow", "version"
  end
end
