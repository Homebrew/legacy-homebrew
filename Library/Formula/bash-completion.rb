# NOTE: version 2.0 is out, but it requires Bash 4, and OS X ships
# with 3.2.48. See homebrew-versions for a 2.0 formula.
class BashCompletion < Formula
  desc "Programmable bash completion"
  homepage "https://bash-completion.alioth.debian.org/"
  url "https://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/bash-completion/bash-completion-1.3.tar.bz2/a1262659b4bbf44dc9e59d034de505ec/bash-completion-1.3.tar.bz2"
  sha256 "8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec"

  bottle do
    sha256 "f522c40d199aff2cdfb71f5b3b17f8e4719e78bed48b13dab1714d3457e93b23" => :yosemite
    sha256 "2f321fe1b85c9df65b1a3a2b4f1aa66189b59fca4d4a2193f35abd697f9fe40b" => :mavericks
    sha256 "1b5bae29dc78c12ac39563380c5bfb84d76094b2661a6c12e19704510981f4e4" => :mountain_lion
  end

  # Backports the following upstream patch from 2.x:
  # https://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=commitdiff_plain;h=50ae57927365a16c830899cc1714be73237bdcb2
  patch :DATA

  def compdir
    etc/"bash_completion.d"
  end

  def install
    inreplace "bash_completion" do |s|
      s.gsub! "/etc/bash_completion", etc/"bash_completion"
      s.gsub! "readlink -f", "readlink"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    unless (compdir/"brew_bash_completion.sh").exist?
      compdir.install_symlink HOMEBREW_CONTRIB/"brew_bash_completion.sh"
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
