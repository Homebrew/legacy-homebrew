require 'formula'

class Plowshare < Formula
  homepage 'http://code.google.com/p/plowshare/'
  url 'https://code.google.com/p/plowshare/', :tag => 'v1.0.5', :using => :git
  head 'https://code.google.com/p/plowshare/', :using => :git

  depends_on 'recode'
  depends_on 'imagemagick' => 'with-x11'
  depends_on 'tesseract'
  depends_on 'spidermonkey'
  depends_on 'aview'
  depends_on 'coreutils'
  depends_on 'gnu-sed'
  depends_on 'gnu-getopt'

  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Plowshare 4 requires Bash 4+. OS X ships with an old Bash 3 version.
    To install Bash 4:
      brew install bash
    EOS
  end
end

# This patch makes sure GNUtools are used on OSX.
# gnu-getopt is keg-only hence the backtick expansion.
# These aliases only exist for the duration of plowshare,
# inside the plowshare shells. Normal operation of bash is
# unaffected - getopt will still find the version supplied
# by OSX in other shells, for example.
__END__
--- a/src/core.sh
+++ b/src/core.sh
@@ -1,4 +1,8 @@
 #!/usr/bin/env bash
+shopt -s expand_aliases
+alias sed='gsed'
+alias getopt='`brew --prefix gnu-getopt`/bin/getopt'
+alias head='ghead'
 #
 # Common set of functions used by modules
 # Copyright (c) 2010 - 2011 Plowshare team

