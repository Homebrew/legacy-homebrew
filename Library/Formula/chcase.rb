class Chcase < Formula
  desc "Perl file-renaming script"
  homepage "http://www.primaledge.ca/chcase.html"
  url "http://www.primaledge.ca/chcase"
  version "2.0"
  sha1 "ec81ad76d85cf9162d422e801092ddc5e0841e39"

  # add a shebang so that brew properly sets it executable
  patch :DATA

  def install
    bin.install "chcase"
  end

  test do
    system bin/"chcase", "-e"
  end
end

__END__
diff --git a/chcase b/chcase
index 689fc79..93efae8
--- a/chcase
+++ b/chcase
@@ -1,3 +1,4 @@
+#!/bin/sh -- # -*- perl -*-
 eval 'exec perl $0 ${1+"$@"}'
 if 0;
 # don't modify below here
