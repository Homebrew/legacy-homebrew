class Eg < Formula
  desc "Expert Guide. Norton Guide Reader For GNU/Linux"
  homepage "http://www.davep.org/norton-guides/"
  url "http://www.davep.org/norton-guides/eg-1.00.tar.gz"
  sha256 "e985b2abd160c5f65bea661de800f0a83f0bfbaca54e5cbdc2e738dfbbdb164e"

  depends_on "s-lang"

  # clang complains about escaped newlines used in the source
  # to form a multiline string. The patch converts said string
  # to a more common C syntax.
  patch :DATA

  def install
    # Change S-Lang header references to the canonical way, otherwise
    # they are not found in the Homebrew environment.
    inreplace %w[
      eg.c
      egcmplte.c
      egdir.c
      egdraw.c
      eggetfld.c
      eghelp.c
      eglib.c
      egmenu.c
      egnavgte.c
      egregex.c
      egscreen.c
      egsigs.c], "<slang/slang.h>", "<slang.h>"
    inreplace "eglib.c", "/usr/share/", "#{HOMEBREW_PREFIX}/share/"
    system "make"
    bin.install "eg"
    man1.install "eg.1"
    # TODO: copy 'default-guide/eg.ng' to '#{HOMEBREW_PREFIX}/share/norton-guides/'
  end

  test do
    # It will return a non-zero exit code when called with any option
    # except a filename, but will return success even if the file
    # doesn't exist, and we're exploiting this here.
    ENV["TERM"] = "xterm"
    system "eg", "not_here.ng"
  end
end

__END__
diff -u a/eg.c b/eg.c
--- a/eg.c
+++ b/eg.c
@@ -174,24 +174,23 @@
     uname( &utsn );
 
     printf( "Expert Guide Version " EG_VERSION "\n\n"
-            "\
-     Expert Guide - A Text Mode Norton Guide Reader
-     Copyright (C) 1997,1998,1999,2000 David A Pearson
-   
-     This program is free software; you can redistribute it and/or modify
-     it under the terms of the GNU General Public License as published by
-     the Free Software Foundation; either version 2 of the license, or 
-     (at your option) any later version.
-     
-     This program is distributed in the hope that it will be useful,
-     but WITHOUT ANY WARRANTY; without even the implied warranty of
-     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-     GNU General Public License for more details.
-     
-     You should have received a copy of the GNU General Public License
-     along with this program; if not, write to the Free Software
-     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-\n" );
+"     Expert Guide - A Text Mode Norton Guide Reader\n"
+"     Copyright (C) 1997,1998,1999,2000 David A Pearson\n"
+"\n"
+"     This program is free software; you can redistribute it and/or modify\n"
+"     it under the terms of the GNU General Public License as published by\n"
+"     the Free Software Foundation; either version 2 of the license, or \n"
+"     (at your option) any later version.\n"
+"\n"
+"     This program is distributed in the hope that it will be useful,\n"
+"     but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
+"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
+"     GNU General Public License for more details.\n"
+"\n"
+"     You should have received a copy of the GNU General Public License\n"
+"     along with this program; if not, write to the Free Software\n"
+"     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.\n"
+"\n" );
     
     printf( "System details:\n"
             "\tSystem.......: %s %s\n"
