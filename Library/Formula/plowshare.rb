class Plowshare < Formula
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.1.tar.gz"
  sha256 "96b3acd1dba1b14f3009334520969af4c00c8f4b7f5d924a26decc4b4a817e53"

  bottle do
    sha256 "1ddafbece256d12f0dacee1f5c68f8878438991878c55889b174dd953bebc4ee" => :yosemite
    sha256 "f97c5f5c9ddc2a99d2e5754d81bf8ddc6ebc647ff822d8231fc7dfb09863cbbc" => :mavericks
    sha256 "33d4072965454972a1b3ba93e67838e8f1bd0fd8914fb0d9ce79eda003895f0d" => :mountain_lion
  end

  depends_on "aview"
  depends_on "bash"
  depends_on "coreutils"
  depends_on "gnu-getopt"
  depends_on "gnu-sed"
  depends_on "imagemagick" => "with-x11"
  depends_on "recode"
  depends_on "spidermonkey"
  depends_on "tesseract"

  # This patch makes sure GNUtools are used on OSX.
  # gnu-getopt is keg-only hence the backtick expansion.
  # These aliases only exist for the duration of plowshare,
  # inside the plowshare shells. Normal operation of bash is
  # unaffected - getopt will still find the version supplied
  # by OSX in other shells, for example.
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end

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

