class ZshHistorySubstringSearch < Formula
  desc "Zsh port of Fish shell's history search"
  homepage "https://github.com/zsh-users/zsh-history-substring-search"
  url "https://github.com/zsh-users/zsh-history-substring-search/archive/v1.0.0.tar.gz"
  sha256 "2b25a06c6d98f8443cfe33187cd31850febaf243c67e551a70cc0030d18443e7"

  def install
    inreplace "README.md", "source zsh-history", "source #{opt_prefix}/zsh-history"
    prefix.install Dir["*.zsh"]
  end

  def caveats; <<-EOS.undent
    For setup instructions:
      more "#{opt_prefix}/README.md"
    EOS
  end
end
