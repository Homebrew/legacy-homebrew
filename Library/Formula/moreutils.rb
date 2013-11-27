require 'formula'

class Moreutils < Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.50.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.50.tar.gz'
  sha1 'f2d2cab5be2ba4b9a568ea32becf866ee4a37d9d'

  conflicts_with 'parallel',
    :because => "both install a 'parallel' executable."

  conflicts_with 'task-spooler',
    :because => "both install a 'ts' executable."

  # To craft manpages
  depends_on 'docbook2x'

  def patches
    # For the MakeFile:
    # - get rid of ifdata which does not build
    # - rename docbook2x-man to docbook2man
    DATA
  end

  def install
    inreplace Dir['*.docbook'],
        'file:///usr/share/xml/docbook/schema/dtd/4.4/docbookx.dtd',
        "#{HOMEBREW_PREFIX}/opt/docbook/docbook/xml/4.4/docbookx.dtd"

    system "make -f MakeFile all"
    system "make -f MakeFile install PREFIX=#{prefix}"
    #bin.install scripts + bins
  end
end

__END__
--- a/MakeFile
+++ b/MakeFile
@@ -1,10 +1,10 @@
-BINS=isutf8 ifdata ifne pee sponge mispipe lckdo parallel errno
+BINS=isutf8 ifne pee sponge mispipe lckdo parallel errno
 PERLSCRIPTS=vidir vipe ts combine zrun chronic
-MANS=sponge.1 vidir.1 vipe.1 isutf8.1 ts.1 combine.1 ifdata.1 ifne.1 pee.1 zrun.1 chronic.1 mispipe.1 lckdo.1 parallel.1 errno.1
+MANS=sponge.1 vidir.1 vipe.1 isutf8.1 ts.1 combine.1 ifne.1 pee.1 zrun.1 chronic.1 mispipe.1 lckdo.1 parallel.1 errno.1
 CFLAGS?=-O2 -g -Wall
 INSTALL_BIN?=install -s
 PREFIX?=/usr
 
-DOCBOOK2XMAN=docbook2x-man
+DOCBOOK2XMAN=docbook2man
 
 all: $(BINS) $(MANS)
