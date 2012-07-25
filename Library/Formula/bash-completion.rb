require 'formula'

# NOTE: version 2.0 is out, but it requires Bash 4, and OS X ships
# with 3.2.48
class BashCompletion < Formula
  homepage 'http://bash-completion.alioth.debian.org/'
  url 'http://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2'
  sha1 '6a46b93f44c56cc336632ab28d90c0595fbcc98f'

  head 'git://git.debian.org/git/bash-completion/bash-completion.git'

  if ARGV.build_head?
    depends_on :autoconf
    depends_on :automake
  end

  def install
    inreplace "bash_completion" do |s|
      s.gsub! '/etc/bash_completion', "#{etc}/bash_completion"
      s.gsub! 'readlink -f', "readlink"
    end

    if ARGV.build_head?
      system "aclocal"
      system "autoconf"
      system "automake --add-missing"
      system "./configure", "--prefix=#{prefix}"

      inreplace 'Makefile' do |s|
        s.change_make_var! "pkgconfigdir", "#{lib}/pkgconfig"
      end
    else
      system "./configure", "--prefix=#{prefix}"
    end

    system "make install"

    # Cause the build to fails if you haven't already installed git or something else that
    # creates a bash_completion.d
    # ln_s "#{HOMEBREW_PREFIX}/Library/Contributions/brew_bash_completion.sh", "#{etc}/bash_completion.d" unless
    #   File.exists? "#{etc}/bash_completion.d/brew_bash_completion.sh" or File.symlink? "#{etc}/bash_completion.d/brew_bash_completion.sh"
  end

  def caveats
    if ARGV.build_head?
      <<-EOS.undent
      Add the following lines to your ~/.bash_profile file:
        if [ -f `brew --prefix`/share/bash-completion/bash_completion ]; then
          . `brew --prefix`/share/bash-completion/bash_completion
        fi

      Some formula install their own completion scripts. To use them with the
      HEAD version of bash-completion, link them into

      #{HOMEBREW_PREFIX}/share/bash-completion/completions

      To install Homebrew's own completion script:
        ln -s "#{HOMEBREW_PREFIX}/Library/Contributions/brew_bash_completion.sh" "#{HOMEBREW_PREFIX}/share/bash-completion/completions"
      EOS
    else
      <<-EOS.undent
      Add the following lines to your ~/.bash_profile file:
        if [ -f `brew --prefix`/etc/bash_completion ]; then
          . `brew --prefix`/etc/bash_completion
        fi

      To install Homebrew's own completion script:
        ln -s "#{HOMEBREW_PREFIX}/Library/Contributions/brew_bash_completion.sh" "#{etc}/bash_completion.d"
      EOS
    end
  end
end
