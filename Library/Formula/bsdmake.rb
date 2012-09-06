require 'formula'

class Bsdmake < Formula
  homepage 'http://opensource.apple.com/'
  url 'http://opensource.apple.com/tarballs/bsdmake/bsdmake-24.tar.gz'
  sha1 '9ce3c3fc01e0eb47d82827b1eb227eb371fefd5c'

  if MacOS::Xcode.provides_autotools? or File.file? "/usr/bin/bsdmake"
    keg_only "Recent versions of OS X no longer provide this tool."
  end

  def patches
    # MacPorts patches to make bsdmake play nice with our prefix system
    { :p0 => %W[
      https://trac.macports.org/export/90868/trunk/dports/devel/bsdmake/files/patch-Makefile.diff
      https://trac.macports.org/export/90611/trunk/dports/devel/bsdmake/files/patch-mk.diff
      https://trac.macports.org/export/90611/trunk/dports/devel/bsdmake/files/patch-pathnames.diff
    ]}
  end

  def install
    # Replace @PREFIX@ inserted by MacPorts patches
    # Use 'prefix' since this is sometimes a keg-only brew
    # But first replace the X11 path if X11 is installed
    inreplace 'mk/sys.mk', '@PREFIX@', MacOS::X11.prefix || prefix
    inreplace %W[mk/bsd.README
                 mk/bsd.cpu.mk
                 mk/bsd.doc.mk
                 mk/bsd.obj.mk
                 mk/bsd.own.mk
                 mk/bsd.port.mk
                 mk/bsd.port.subdir.mk
                 pathnames.h],
                 '@PREFIX@', prefix

    inreplace 'mk/bsd.own.mk' do |s|
      s.gsub! '@INSTALL_USER@', `id -un`.chomp
      s.gsub! '@INSTALL_GROUP@', `id -gn`.chomp
    end

    # See GNUMakefile
    ENV.append 'CFLAGS', '-D__FBSDID=__RCSID'
    ENV.append 'CFLAGS', '-mdynamic-no-pic'

    system "make", "-f", "Makefile.dist"
    bin.install 'pmake' => 'bsdmake'
    man1.install 'make.1' => 'bsdmake.1'
    (share/'mk/bsdmake').install Dir['mk/*']
  end
end
