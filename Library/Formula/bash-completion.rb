require 'formula'

class BashCompletion < Formula
  homepage 'http://bash-completion.alioth.debian.org/'
  url 'http://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2'
  sha256 '8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec'
  head 'git://git.debian.org/git/bash-completion/bash-completion.git'

  def install
    inreplace "bash_completion" do |s|
      s.gsub! '/etc/bash_completion', "#{etc}/bash_completion"
      s.gsub! 'readlink -f', "readlink"
    end

    if ARGV.build_head?
      system "aclocal"
      system "autoreconf -f -i -Wall,no-obsolete"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # Cause the build to fails if you haven't already installed git or something else that
    # creates a bash_completion.d
    # ln_s "#{HOMEBREW_PREFIX}/Library/Contributions/brew_bash_completion.sh", "#{etc}/bash_completion.d" unless
    #   File.exists? "#{etc}/bash_completion.d/brew_bash_completion.sh" or File.symlink? "#{etc}/bash_completion.d/brew_bash_completion.sh"
  end

  def caveats; <<-EOS
Add the following lines to your ~/.bash_profile file:
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi

To install Homebrew's own completion script:
  ln "#{HOMEBREW_PREFIX}/Library/Contributions/brew_bash_completion.sh" "#{etc}/bash_completion.d"
    EOS
  end
end
