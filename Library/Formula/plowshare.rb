require 'formula'

class Plowshare < Formula
  homepage 'http://code.google.com/p/plowshare/'
  url 'http://plowshare.googlecode.com/files/plowshare4-snapshot-git20130901.1c5013f.tar.gz'
  version '4.GIT-1c5013f'
  sha1 '57f2351d0136ad7a79e99c12be230b144166afaf'

  head 'https://code.google.com/p/plowshare/', :using => :git

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

  def caveats; <<-EOS.undent
    The default installation of imagemagick does not enable
    X11 support. plowshare uses the display command which does
    not work if X11 support is not enabled. To enable:
      brew remove imagemagick
      brew install imagemagick --with-x

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

