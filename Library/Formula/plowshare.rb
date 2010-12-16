require 'formula'

class Plowshare <Formula
  head 'http://plowshare.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/plowshare/'

  depends_on 'recode'
  depends_on 'imagemagick'
  depends_on 'tesseract'
  depends_on 'spidermonkey'
  depends_on 'aview'
  depends_on 'coreutils'
  depends_on 'gnu-sed'
  depends_on 'gnu-getopt'

  def patches
    DATA
  end

  def install
    ENV["PREFIX"] = prefix
    system "bash setup.sh install"
  end
end


#This patch makes sure GNUtools are used on OSX.
#gnu-getopt is keg-only hence the backtick expansion.
#These aliases only exist for the duration of plowshare,
#inside the plowshare shells. Normal operation of bash is
#unaffected - getopt will still find the version supplied
#by OSX in other shells, for example.
__END__
--- a/src/lib.sh
+++ b/src/lib.sh
@@ -1,4 +1,8 @@
 #!/bin/bash
+shopt -s expand_aliases
+alias sed='gsed'
+alias getopt='`brew --prefix gnu-getopt`/bin/getopt'
+alias head='ghead'
 #
 # This file is part of Plowshare.
 #

