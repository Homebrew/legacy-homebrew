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
      https://trac.macports.org/export/87593/trunk/dports/textproc/openjade/files/patch-Node.h ] +
    # Patch for building with clang compiler
      %W[ https://raw.github.com/gist/3732794/7d0c7d269bbf9d93b394b52e68810615d9aa33cb/default-ctor.patch ] +
    # Patch for correct handling libtool library
      %W[ https://raw.github.com/gist/3732807/1400a70e6396f2c2f3d90a0ca1035e7a79ae8bd6/Makefile.prog.in.patch ]
      }
  end

  def install
    ENV.append 'CXXFLAGS', '-fno-rtti'

    system "./configure", "--enable-http",
                          "--enable-html",
                          "--enable-mif",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datadir=#{share}/sgml/openjade",
                          "--enable-default-catalog=#{share}/sgml/catalog",
                          "--enable-default-search-path=#{share}/sgml"

    # Patch libtool because it doesn't know about CXX
    inreplace 'libtool' do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CXX", ENV.cxx
    end

    system "make"
    system "make", "install"

    # Install additional dsssl
    subdir = 'sgml/openjade'
    (share+subdir).mkpath
    (share+subdir).install Dir['dsssl/*']

    # Link additional catalogs to the root catalog

    catalog_sgml = etc + 'sgml/catalog'
    catalog_openjade = share + 'sgml/catalog'

    # Create the root catalog file if it doesn't exist
    (etc+'sgml').mkpath

    if !File.file?(catalog_sgml)
      system "xmlcatmgr -s -c #{catalog_sgml} create"
    end

    # Create the intermediate openjade catalog file
    # in share/sgml/catalog and reference a root catalog from it.
    if !File.file?(catalog_openjade)
      system "xmlcatmgr -s -c #{catalog_openjade} create"
    end

    # Add the root catalog to openjade's intermediate catalog
    begin
      safe_system "xmlcatmgr -s -c #{catalog_openjade} lookup #{catalog_sgml}"
    rescue ErrorDuringExecution
      system "xmlcatmgr -s -c #{catalog_openjade} add CATALOG #{catalog_sgml}"
    end

    # Add openjade's catalog to the root catalog
    begin
      safe_system "xmlcatmgr -s -c #{catalog_sgml} lookup #{share}/sgml/openjade/catalog"
    rescue ErrorDuringExecution
      system "xmlcatmgr -s -c #{catalog_sgml} add CATALOG #{share}/sgml/openjade/catalog"
    end
  end
end
