require 'formula'

class GitAchievements < Formula
  head 'git://github.com/icefox/git-achievements.git'
  homepage 'https://github.com/icefox/git-achievements'

  def install
    bin.install 'git-achievements'
  end

  def caveats; <<-EOS
Add the following lines to your ~/.bash_profile or ~/.profile file:
  if [ -f #{HOMEBREW_PREFIX}/bin/git-achievements ]; then
    alias git="#{HOMEBREW_PREFIX}/bin/git-achievements"
  fi
    EOS
  end
end
