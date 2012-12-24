require 'formula'

class Reposurgeon < Formula
  url 'http://www.catb.org/~esr/reposurgeon/reposurgeon-2.11.tar.gz'
  homepage 'http://www.catb.org/esr/reposurgeon/'
  sha1 '135582528f95794eac84e6392e3300b3e6ee9dd2'

  depends_on 'asciidoc'
  depends_on 'xmlto'

  def patches
    DATA # https://github.com/mxcl/homebrew/issues/16717
  end

  def install
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"
    system "make"
    bin.install "reposurgeon"
    man1.install "reposurgeon.1"
    bin.install "repopuller"
    man1.install "repopuller.1"
    bin.install "repodiffer"
    man1.install "repodiffer.1"
  end
end

__END__
--- a/repodiffer.xml
+++ b/repodiffer.xml
@@ -1,7 +1,7 @@
 <?xml version="1.0" encoding="ISO-8859-1"?>
 <!DOCTYPE refentry PUBLIC 
-   "-//OASIS//DTD DocBook XML V4.1.2//EN"
-   "docbook/docbookx.dtd">
+   "-//OASIS//DTD DocBook XML V4.2//EN"
+   "docbookx.dtd">
 <refentry id='repodiffer.1'>
 <refmeta>
 <refentrytitle>repodiffer</refentrytitle>
--- a/repopuller.xml
+++ b/repopuller.xml
@@ -1,7 +1,7 @@
 <?xml version="1.0" encoding="ISO-8859-1"?>
 <!DOCTYPE refentry PUBLIC 
-   "-//OASIS//DTD DocBook XML V4.1.2//EN"
-   "docbook/docbookx.dtd">
+   "-//OASIS//DTD DocBook XML V4.2//EN"
+   "docbookx.dtd">
 <refentry id='repopuller.1'>
 <refmeta>
 <refentrytitle>repopuller</refentrytitle>
--- a/reposurgeon.xml
+++ b/reposurgeon.xml
@@ -1,7 +1,7 @@
 <?xml version="1.0" encoding="ISO-8859-1"?>
 <!DOCTYPE refentry PUBLIC 
-   "-//OASIS//DTD DocBook XML V4.1.2//EN"
-   "docbook/docbookx.dtd">
+   "-//OASIS//DTD DocBook XML V4.2//EN"
+   "docbookx.dtd">
 <refentry id='reposurgeon.1'>
 <refmeta>
 <refentrytitle>reposurgeon</refentrytitle>
