require 'formula'

class GitNow < Formula
  homepage 'https://github.com/iwata/git-now'
  url 'https://github.com/iwata/git-now.git', :tag => 'v0.1.0.9'
  version '0.1.0.9'

  head 'https://github.com/iwata/git-now.git', :branch => 'develop'

  depends_on 'gnu-getopt'

  def patches
    DATA
  end

  def install
    system "make", "prefix=#{prefix}", "install"
    (share+'zsh/site-functions').install 'etc/_git-now'
  end

  def caveats; <<-EOS.undent
   Zsh completion has been installed to:
      #{HOMEBREW_PREFIX}/zsh/site-functions
    EOS
  end
end

# This patch makes sure GNUtools are used on OSX.
# gnu-getopt is keg-only hence the backtick expansion.
# These aliases only exist for the duration of git-now,
# inside the git-now shells. Normal operation of bash is
# unaffected - getopt will still find the version supplied
# by OSX in other shells, for example.
__END__
--- a/git-now
+++ b/git-now
@@ -1,5 +1,7 @@
 #!/bin/sh

+alias getopt='`brew --prefix gnu-getopt`/bin/getopt'
+
 # enable debug mode
 if [ "$DEBUG" = "yes" ]; then
   set -x

