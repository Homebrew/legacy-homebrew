class Gws < Formula
  homepage "https://streakycobra.github.io/gws/"
  url "https://github.com/StreakyCobra/gws/archive/0.1.7.tar.gz"
  sha256 "36c25392f5cb93a39441a1973842249a62b605a2a7e369a040c78450683697d0"

  depends_on "bash"

  def install
    bin.install "src/gws"

    bash_completion.install "completions/bash"
    zsh_completion.install "completions/zsh"
  end

  test do
    system "git", "init", "#{testpath}/project"
    system "#{bin}/gws", "init", "#{testpath}"
    output = shell_output("#{bin}/gws status #{testpath}")
    assert_equal "project:\n                              Clean [Local only repository]\n", output
  end
end

