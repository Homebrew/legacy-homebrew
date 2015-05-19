require 'formula'

class ZshHistorySubstringSearch < Formula
  desc "A zsh port of Fish shell's history search"
  homepage 'https://github.com/zsh-users/zsh-history-substring-search'
  url 'https://github.com/zsh-users/zsh-history-substring-search/archive/v1.0.0.tar.gz'
  sha1 'c64cab22664fc62479ccf687ba55410177a3f5d6'

  def install
    inreplace "README.md", "source zsh-history", "source #{opt_prefix}/zsh-history"
    prefix.install Dir['*.zsh']
  end

  def caveats; <<-EOS.undent
    For setup instructions:
      more "#{opt_prefix}/README.md"
    EOS
  end
end
