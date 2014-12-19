require "formula"

class Bsdmake < Formula
  homepage "http://opensource.apple.com/"
  url "http://opensource.apple.com/tarballs/bsdmake/bsdmake-24.tar.gz"
  sha1 "9ce3c3fc01e0eb47d82827b1eb227eb371fefd5c"

  bottle do
    revision 1
    sha1 "af9a7d65b92a9c5fae42bd3653d4b79c249e8c18" => :yosemite
    sha1 "e7530cee7765619355ad4ff07ff3a9635c5f843c" => :mavericks
    sha1 "cbb0f8c89812af75e3f4ba99951d8b440db5660e" => :mountain_lion
  end

  keg_only :provided_until_xcode43

  # MacPorts patches to make bsdmake play nice with our prefix system
  # Also a MacPorts patch to circumvent setrlimit error
  patch :p0 do
    url "https://trac.macports.org/export/90868/trunk/dports/devel/bsdmake/files/patch-Makefile.diff"
    sha1 "d09ea3742fd2cff97bf28510b585751b47ecd067"
  end

  patch :p0 do
    url "https://trac.macports.org/export/90611/trunk/dports/devel/bsdmake/files/patch-mk.diff"
    sha1 "cf3ea9a27e225bdb28573222acf7f0db533cf8b7"
  end

  patch :p0 do
    url "https://trac.macports.org/export/90611/trunk/dports/devel/bsdmake/files/patch-pathnames.diff"
    sha1 "0797e402973aeccae41a82f5a9e444739948edc8"
  end

  patch :p0 do
    url "https://trac.macports.org/export/105220/trunk/dports/devel/bsdmake/files/patch-setrlimit.diff"
    sha1 "c3fb48eb24e01aef2bba7e528442330c1af4a2ce"
  end

  def install
    # Replace @PREFIX@ inserted by MacPorts patches
    # Use "prefix" since this is sometimes a keg-only brew
    # But first replace the X11 path if X11 is installed
    inreplace "mk/sys.mk", "@PREFIX@", MacOS::X11.prefix || prefix
    inreplace %W[mk/bsd.README
                 mk/bsd.cpu.mk
                 mk/bsd.doc.mk
                 mk/bsd.obj.mk
                 mk/bsd.own.mk
                 mk/bsd.port.mk
                 mk/bsd.port.subdir.mk
                 pathnames.h],
                 "@PREFIX@", prefix

    inreplace "mk/bsd.own.mk" do |s|
      s.gsub! "@INSTALL_USER@", `id -un`.chomp
      s.gsub! "@INSTALL_GROUP@", `id -gn`.chomp
    end

    # See GNUMakefile
    ENV.append "CFLAGS", "-D__FBSDID=__RCSID"
    ENV.append "CFLAGS", "-mdynamic-no-pic"

    system "make", "-f", "Makefile.dist"
    bin.install "pmake" => "bsdmake"
    man1.install "make.1" => "bsdmake.1"
    (share/"mk/bsdmake").install Dir["mk/*"]
  end
end
