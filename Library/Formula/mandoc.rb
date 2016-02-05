class Mandoc < Formula
  desc "The mandoc UNIX manpage compiler toolset"
  homepage "http://mdocml.bsd.lv"
  url "http://mdocml.bsd.lv/snapshots/mdocml-1.13.3.tar.gz"
  sha256 "23ccab4800d50bf4c327979af5d4aa1a6a2dc490789cb67c4c3ac1bd40b8cad8"

  bottle do
    sha256 "15a8ba3a50c95ba6c5b02fd77991fd0f5e9cd8fccfed9c96b9f6afb171cbffba" => :yosemite
    sha256 "66bf930eb1fbbe1be9cfab3f5a4d2582de2f9cd550d5e98894513d75f62e4ef2" => :mavericks
    sha256 "79987dc1387313f384f8943306a41b37ee2b35ca90d06456a956b79fbaf61673" => :mountain_lion
  end

  head "anoncvs@mdocml.bsd.lv:/cvs", :module => "mdocml", :using => :cvs

  option "without-sqlite", "Only install the mandoc/demandoc utilities."
  option "without-cgi", "Don't build man.cgi (and extra CSS files)."

  depends_on "sqlite" => :recommended

  def install
    localconfig = [

      # Sane prefixes.
      "PREFIX=#{prefix}",
      "INCLUDEDIR=#{include}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man}",
      "WWWPREFIX=#{prefix}/var/www",
      "EXAMPLEDIR=#{share}/examples",

      # Executable names, where utilities would be replaced/duplicated.
      # The mdocml versions of the utilities are definitely *not* ready
      # for prime-time on Darwin, though some changes in HEAD are promising.
      # The "bsd" prefix (like bsdtar, bsdmake) is more informative than "m".
      "BINM_MAN=bsdman",
      "BINM_APROPOS=bsdapropos",
      "BINM_WHATIS=bsdwhatis",
      "BINM_MAKEWHATIS=bsdmakewhatis",	# default is "makewhatis".

      # These are names for *section 7* pages only. Several other pages are
      # prefixed "mandoc_", similar to the "groff_" pages.
      "MANM_MAN=man",
      "MANM_MDOC=mdoc",
      "MANM_ROFF=mandoc_roff", # This is the only one that conflicts (groff).
      "MANM_EQN=eqn",
      "MANM_TBL=tbl",

      "OSNAME='Mac OS X #{MacOS.version}'", # Bottom corner signature line.

      # Not quite sure what to do here. The default ("/usr/share", etc.) needs
      # sudoer privileges, or will error. So just brew's manpages for now?
      "MANPATH_DEFAULT=#{HOMEBREW_PREFIX}/share/man",

      "HAVE_MANPATH=0",   # Our `manpath` is a symlink to system `man`.
      "STATIC=",          # No static linking on Darwin.

      "HOMEBREWDIR=#{HOMEBREW_CELLAR}" # ? See configure.local.example, NEWS.
    ]

    localconfig << "BUILD_DB=1" if build.with? "db"
    localconfig << "BUILD_CGI=1" if build.with? "cgi"
    File.rename("cgi.h.example", "cgi.h") # For man.cgi, harmless in any case.

    (buildpath/"configure.local").write localconfig.join("\n")
    system "./configure"

    # I've tried twice to send a bug report on this to tech@mdocml.bsd.lv.
    # In theory, it should show up with:
    # search.gmane.org/?query=jobserver&group=gmane.comp.tools.mdocml.devel
    ENV.deparallelize do
      system "make"
      system "make", "install"
    end

    system "make", "manpage" # Left out of the install for some reason.
    bin.install "manpage"
  end

  test do
    system "mandoc", "-Thtml",
      "-Ostyle=#{share}/examples/example.style.css",
      "#{HOMEBREW_PREFIX}/share/man/man1/brew.1"
  end
end
