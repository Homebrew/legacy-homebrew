require 'formula'

def option? opt
  build.include? opt or build.include? 'with-all'
end

class Pike < Formula
  homepage 'http://pike.lysator.liu.se'
  url 'http://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v7.8.700.tar.gz'
  sha1 '877bd50d2bb202aa485d1f7c62398922d60696c7'

  depends_on "nettle"
  depends_on "gmp"
  depends_on "pcre"
  depends_on :x11 => :recommended
  depends_on 'libtiff' => :recommended

  # optional dependencies
  depends_on 'gettext'       if option? 'with-gettext'
  depends_on 'gdbm'          if option? 'with-gdbm'
  depends_on 'gtk+'          if option? 'with-gtk2'
  depends_on 'mysql'         if option? 'with-mysql'
  depends_on 'sdl'           if option? 'with-sdl'
  depends_on 'sane-backends' if option? 'with-sane'
  depends_on 'pdflib-lite'   if option? 'with-pdf'
  depends_on 'mesalib-glw'   if option? 'with-gl'

  option 'with-gettext', 'Include Gettext support'
  option 'with-gdbm', 'Include Gdbm support'
  option 'with-gtk2', 'Include GTK2 support'
  option 'with-mysql', 'Include Mysql support'
  option 'with-pcre', 'Include Regexp.PCRE support'
  option 'with-sdl', 'Include SDL support'
  option 'with-sane', 'Include Sane support'
  option 'with-pdf', 'Include PDF support'
  option 'with-gl', 'Include GL support'
  option 'with-all', 'Include all features'
  option 'with-machine-code', 'Enables machine code'

  fails_with :llvm do
    build 2335
    cause "Fails to build multiset.c, results in a Abort trap being caught."
  end

  def install
    args = ["--prefix=#{prefix}", "--without-bundles"]

    if MacOS.prefer_64_bit? and not build.build_32_bit?
      ENV.append 'CFLAGS', '-m64'
      args << "--with-abi=64"
    else
      ENV.append 'CFLAGS', '-m32'
      args << "--with-abi=32"
    end

    unless build.include? 'with-machine-code'
      args << "--without-machine-code"
    end

    ENV.j1

    system "make", "CONFIGUREARGS='" + args.join(' ') + "'"

    # installation is complicated by some of brew's standard patterns.
    # hopefully these notes explain the reasons for diverging from
    # the path that most other formulae use.
    #
    # item 1
    #
    # basically, pike already installs itself naturally as brew would want
    # it; that is, if prefix=/Cellar, installation would create
    # /Cellar/pike/ver/bin and so forth. We could just go with that, but it's
    # possible that homebrew might change its layout and then the formula
    # would no longer work.
    #
    # so, rather than guessing at it, we do this alternate gyration, forcing
    # pike to install in a slightly nonstandard way (for pike, at least)
    #
    # item 2
    #
    # a second problem crops up because the during installation, the link
    # function tries to pull in stuff from lib/, which is really more like
    # what one would expect share or libexec in homebrew might be: pike
    # specific files, rather than shared libraries. we could approach this
    # in a similar fashion, but the result would be a really odd arrangement
    # for anyone remotely familar with standard pike installs.
    #
    # because there's no way to override the keg.link command, this formula
    # installs the whole pike install into prefix/libexec and then links the
    # man page and binary back into prefix/share and prefix/bin. not so
    # elegant, but that's the way brew works.
    system "make",  "install",
                    "prefix=#{libexec}",
                    "exec_prefix=#{libexec}",
                    "share_prefix=#{libexec}/share",
                    "lib_prefix=#{libexec}/lib",
                    "man_prefix=#{libexec}/man",
                    "include_path=#{libexec}/include",
                    "INSTALLARGS=--traditional"

   bin.install_symlink "#{libexec}/bin/pike"
   share.install_symlink "#{libexec}/share/man"
  end
end
