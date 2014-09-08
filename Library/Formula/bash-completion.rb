require 'formula'

# NOTE: version 2.0 is out, but it requires Bash 4, and OS X ships
# with 3.2.48. See homebrew-versions for a 2.0 formula.
class BashCompletion < Formula
  homepage 'http://bash-completion.alioth.debian.org/'
  url 'http://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2'
  mirror 'http://pkgs.fedoraproject.org/repo/pkgs/bash-completion/bash-completion-1.3.tar.bz2/a1262659b4bbf44dc9e59d034de505ec/bash-completion-1.3.tar.bz2'
  sha1 '6a46b93f44c56cc336632ab28d90c0595fbcc98f'

  # Backports the following upstream patch from 2.x:
  # http://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=patch;h=50ae57927365a16c830899cc1714be73237bdcb2
  patch :DATA

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

__END__
diff --git a/bash_completion b/bash_completion
index 6601937..5184767 100644
--- a/bash_completion
+++ b/bash_completion
@@ -1334,7 +1334,7 @@ _known_hosts_real()
 
     # append any available aliases from config files
     if [[ ${#config[@]} -gt 0 && -n "$aliases" ]]; then
-        local hosts=$( sed -ne 's/^[ \t]*[Hh][Oo][Ss][Tt]\([Nn][Aa][Mm][Ee]\)\{0,1\}['"$'\t '"']\{1,\}\([^#*?]*\)\(#.*\)\{0,1\}$/\2/p' "${config[@]}" )
+        local hosts=$( sed -ne 's/^['"$'\t '"']*[Hh][Oo][Ss][Tt]\([Nn][Aa][Mm][Ee]\)\{0,1\}['"$'\t '"']\{1,\}\([^#*?]*\)\(#.*\)\{0,1\}$/\2/p' "${config[@]}" )
         COMPREPLY=( "${COMPREPLY[@]}" $( compgen  -P "$prefix$user" \
             -S "$suffix" -W "$hosts" -- "$cur" ) )
     fi
