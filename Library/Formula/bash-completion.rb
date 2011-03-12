require 'formula'

class BashCompletion <Formula
  url 'http://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2'
  homepage 'http://bash-completion.alioth.debian.org/'
  md5 'a1262659b4bbf44dc9e59d034de505ec'
  head 'git://git.debian.org/git/bash-completion/bash-completion.git'

  def install
    inreplace "bash_completion" do |s|
      s.gsub! '/etc/bash_completion', "#{etc}/bash_completion"
      s.gsub! 'readlink -f', "readlink"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"

    ln_s "#{HOMEBREW_PREFIX}/Library/Contributions/brew_bash_completion.sh", "#{etc}/bash_completion.d" unless
      File.exists? "#{etc}/bash_completion.d/brew_bash_completion.sh" or File.symlink? "#{etc}/bash_completion.d/brew_bash_completion.sh"
  end

  def caveats; <<-EOS
Add the following lines to your ~/.bash_profile file:
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
    EOS
  end
end
