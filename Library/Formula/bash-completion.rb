# NOTE: version 2.0 is out, but it requires Bash 4, and OS X ships
# with 3.2.48. See homebrew-versions for a 2.0 formula.
class BashCompletion < Formula
  desc "Programmable bash completion"
  homepage "https://bash-completion.alioth.debian.org/"
  url "https://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/bash-completion/bash-completion-1.3.tar.bz2/a1262659b4bbf44dc9e59d034de505ec/bash-completion-1.3.tar.bz2"
  sha256 "8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "fa3223e326e3319c261bbd1b289da4118e7a38887494b82aa4a67c99c6eb99ef" => :el_capitan
    sha256 "0968d379dccbb2c63459aa20a97df8422740fedb599d529735c01750543792a4" => :yosemite
    sha256 "7b9e7523a70c0dd79dc3eaa9c868660f0e5bce07d03ce66621535233504903ec" => :mavericks
  end

  # Backports the following upstream patch from 2.x:
  # https://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=commitdiff_plain;h=50ae57927365a16c830899cc1714be73237bdcb2
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740971
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
@@ -640,7 +640,7 @@

     _quote_readline_by_ref "$cur" quoted
     toks=( ${toks[@]-} $(
-        compgen -d -- "$quoted" | {
+        compgen -d -- "$cur" | {
             while read -r tmp; do
                 # TODO: I have removed a "[ -n $tmp ] &&" before 'printf ..',
                 #       and everything works again. If this bug suddenly
@@ -1334,7 +1334,7 @@ _known_hosts_real()
 
     # append any available aliases from config files
     if [[ ${#config[@]} -gt 0 && -n "$aliases" ]]; then
-        local hosts=$( sed -ne 's/^[ \t]*[Hh][Oo][Ss][Tt]\([Nn][Aa][Mm][Ee]\)\{0,1\}['"$'\t '"']\{1,\}\([^#*?]*\)\(#.*\)\{0,1\}$/\2/p' "${config[@]}" )
+        local hosts=$( sed -ne 's/^['"$'\t '"']*[Hh][Oo][Ss][Tt]\([Nn][Aa][Mm][Ee]\)\{0,1\}['"$'\t '"']\{1,\}\([^#*?]*\)\(#.*\)\{0,1\}$/\2/p' "${config[@]}" )
         COMPREPLY=( "${COMPREPLY[@]}" $( compgen  -P "$prefix$user" \
             -S "$suffix" -W "$hosts" -- "$cur" ) )
     fi
