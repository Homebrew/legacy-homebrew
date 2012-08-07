# Ported from openjade MacPort. Uses some patches and catalog generator
#
require 'formula'

class OpenJade < Formula
  url 'http://downloads.sourceforge.net/project/openjade/openjade/1.3.2/openjade-1.3.2.tar.gz'
  homepage 'http://openjade.sourceforge.net'
  sha1 '54e1999f41450fbd62c5d466002d79d3efca2321'

  depends_on 'xmlcatmgr' => :build
  depends_on 'open-sp' => :build

  def patches
    # MacPorts patches for building openjade at a modern os x
    { :p0 => %W[
      https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Makefile.lib.in
      https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Makefile.prog.in
      https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-ltmain.sh
      https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-configure
      https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-GroveApp.h
      https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-GroveBuilder.cxx
      https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Node.h
    ],
    # Patch for building with clang compiler
    # Patch for correct handling libtool library
    :p1 => %W[
      https://raw.github.com/gist/3732794/e6dfeac65c579c6f05c0ab19449ee30bacd4aee0/default-ctor.patch
      https://raw.github.com/gist/3732807/79cd6f7eec656861f87e71c25ae3f947d36d22f4/Makefile.prog.in.patch
    ] }
  end

  def install
    ENV.append 'CXXFLAGS', '-fno-rtti'

    system "./configure", "--enable-http",
                          "--enable-html",
                          "--enable-mif",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-default-catalog=#{share}/sgml/catalog",
                          "--datadir=#{share}/sgml/openjade"

    # Patch libtool because it doesn't know about CXX
    inreplace 'libtool' do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CXX", ENV.cxx
    end

    system "make"
    system "make", "install"

    puts "Install additional dsssl"
    subdir = 'sgml/openjade'
    (share+subdir).mkpath
    (share+subdir).install Dir['dsssl/*']

    # Note from original macport:
    #
    # xmlcatmgr as installed by MacPorts defaults to using
    # ${prefix}/etc/sgml/catalog (for XML) and ${prefix}/etc/sgml/catalog (for
    # SGML). For historic reasons, openjade expects the catalog to be in
    # share/sgml/catalog. To avoid breaking existing setup, we simply add
    # a reference to the root catalog (/etc/sgml/catalog) to openjade's
    # catalog (/share/sgml/catalog)
    #
    puts "Link additional catalog"
    catalog_sgml = etc + 'sgml/catalog'
    catalog_openjade = share + 'sgml/catalog'

    # Create the root catalog file if it doesn't exist
    (etc+'sgml').mkpath

    # Create the root catalog file if it doesn't exist
    if !File.file?(catalog_sgml)
      system "xmlcatmgr -s -c #{catalog_sgml} create"
    end

    # Create the openjade catalog file if it doesn't exist
    if !File.file?(catalog_openjade)
      system "xmlcatmgr -s -c #{catalog_openjade} create"
    end

    # Add the root catalog to openjade's catalog
    begin
      safe_system "xmlcatmgr -s -c #{catalog_openjade} lookup #{catalog_sgml}"
    rescue ErrorDuringExecution
      system "xmlcatmgr -s -c #{catalog_openjade} add CATALOG #{catalog_sgml}"
    end

    # And add openjade's catalog to the root catalog
    begin
      safe_system "xmlcatmgr -s -c #{catalog_sgml} lookup #{share}/sgml/openjade/catalog"
    rescue ErrorDuringExecution
      system "xmlcatmgr -s -c #{catalog_sgml} add CATALOG #{share}/sgml/openjade/catalog"
    end
  end
end
