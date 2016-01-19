class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.2.tar.gz"
  sha256 "d9b9f2aa464d7d2966f49704234c79139d1162705a0a553a3059c68fbf4be21a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf51f7730cba1c919599fd682cf39ef5ee3f4583da7b54c7e454681d48f686af" => :el_capitan
    sha256 "5fdbb23c6c90d72d9e362ab4a8ed3b65bf3b9c9a5a82e233d73f66863098e945" => :yosemite
    sha256 "fd04155ae4e86884f63731834f4a5b4b4746d534d376d091bc7df76065734646" => :mavericks
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
