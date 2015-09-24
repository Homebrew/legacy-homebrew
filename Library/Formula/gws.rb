class Gws < Formula
  homepage "https://streakycobra.github.io/gws/"
  desc "Manage workspaces composed of git repositories"
  url "https://github.com/StreakyCobra/gws/archive/0.1.8.tar.gz"
  sha256 "c240601b0adcc5ae402199217fc0d5fd6775ada69919a860ad3c1c4b16805e63"

  depends_on "bash"
  depends_on "coreutils" # see bug https://github.com/StreakyCobra/gws/issues/17
  depends_on "gnu-sed" # see bug https://github.com/StreakyCobra/gws/issues/17

  def install
    bin.install "src/gws"

    # Add GNU's 'sed' and 'cut' to PATH to fix bug
    inreplace "#{bin}/gws" do |s|
      s.sub! /VERSION="0.1.8"/, "VERSION=\"0.1.8\"\nexport PATH=#{gws_gnu_path}"
    end

    bash_completion.install "completions/bash"
    zsh_completion.install "completions/zsh"
  end

  def gws_gnu_path; <<-EOS.undent
    "#{Formula["coreutils"].opt_libexec}/gnubin:#{Formula["gnu-sed"].opt_libexec}/gnubin:$PATH"
    EOS
  end

  def caveats; <<-EOS.undent
    A bug introduced in 0.1.8 (https://github.com/StreakyCobra/gws/issues/17)
    makes gws use some options that are specific to	GNU's 'sed' and 'cut',
    which are not available to OSX.

    gws script has been updated to include GNU's sed and cut in PATH
    EOS
  end

  test do
    system "git", "init", "project"
    system "#{bin}/gws", "init"
    output = shell_output("#{bin}/gws status")
    assert_equal "project:\n                              Clean [Local only repository]\n", output
  end
end

