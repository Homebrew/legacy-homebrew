class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.1.tar.gz"
  sha256 "96b3acd1dba1b14f3009334520969af4c00c8f4b7f5d924a26decc4b4a817e53"

  bottle do
    sha256 "f8337922b92d53f801a91b71b28c6cf0160c9acdf92ee8a95009606d0a4f9109" => :yosemite
    sha256 "1fc4fd994f341d73c252b6f9bb7918f307bb245e6ee4d63d8247d81143262eb2" => :mavericks
    sha256 "76caa88591b4d4832bf0b4e8674816672850f88baec7293290cb7eca1d19db17" => :mountain_lion
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

