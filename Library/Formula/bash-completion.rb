require 'formula'

# NOTE: version 2.0 is out, but it requires Bash 4, and OS X ships
# with 3.2.48. See homebrew-versions for a 2.0 formula.
class BashCompletion < Formula
  homepage 'http://bash-completion.alioth.debian.org/'
  url 'http://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2'
  sha1 '6a46b93f44c56cc336632ab28d90c0595fbcc98f'

  def compdir
    etc/'bash_completion.d'
  end

  def install
    inreplace "bash_completion" do |s|
      s.gsub! '/etc/bash_completion', etc/'bash_completion'
      s.gsub! 'readlink -f', "readlink"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"

    unless (compdir/'brew_bash_completion.sh').exist?
      compdir.install_symlink HOMEBREW_CONTRIB/'brew_bash_completion.sh'
    end
  end

  def caveats; <<-EOS.undent
    Add the following lines to your ~/.bash_profile:
      if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
      fi

    Homebrew's own bash completion script has been installed to
      #{compdir}
    EOS
  end
end
