require 'formula'

class Pike < Formula
  homepage 'http://pike.ida.liu.se'
  url 'http://pike.ida.liu.se/pub/pike/all/7.8.700/Pike-v7.8.700.tar.gz'
  sha1 '877bd50d2bb202aa485d1f7c62398922d60696c7'

  linked = 0

  # really necessary
  depends_on "nettle"
  depends_on "gmp"

  # one might argue that these aren't completely necessary
  depends_on :x11
  depends_on 'libtiff'

  # optional dependencies
  depends_on 'gettext' if ARGV.include? '--with-gettext' or ARGV.include? '--with-all'
  depends_on 'gdbm' if ARGV.include? '--with-gdbm' or ARGV.include? '--with-all'
  depends_on 'gtk+' if ARGV.include? '--with-gtk2' or ARGV.include? '--with-all'
  depends_on 'mysql' if ARGV.include? '--with-mysql' or ARGV.include? '--with-all'
  depends_on 'pcre' if ARGV.include? '--with-pcre' or ARGV.include? '--with-all'
  depends_on 'sdl' if ARGV.include? '--with-sdl' or ARGV.include? '--with-all'
  depends_on 'sane-backends' if ARGV.include? '--with-sane' or ARGV.include? '--with-all'
  depends_on 'pdflib-lite' if ARGV.include? '--with-pdf' or ARGV.include? '--with-all'
  depends_on 'mesalib-glw' if ARGV.include? '--with-gl' or ARGV.include? '--with-all'

  def options
   [
     ['--with-gettext', 'Include Gettext support'],
     ['--with-gdbm', 'Include Gdbm support'],
     ['--with-gtk2', 'Include GTK2 support'],
     ['--with-mysql', 'Include Mysql support'],
     ['--with-pcre', 'Include Regexp.PCRE support'],
     ['--with-sdl', 'Include SDL support'],
     ['--with-sane', 'Include Sane support'],
     ['--with-pdf', 'Include PDF support'],
     ['--with-gl', 'Include GL support'],
     ['--with-all', 'Include all features'],
     ['--with-machine-code', 'Enables machine code'],
   ]
  end
  
  fails_with :llvm do
    build 2335
    cause <<-EOS.undent
      Fails to build multiset.c, results in a Abort trap being caught.
      EOS
  end

  def install
    cargs = [ "--prefix=#{prefix}",
             "--without-bundles"
           ]

    if MacOS.prefer_64_bit? and not ARGV.build_32_bit?
      ENV.append 'CFLAGS', '-m64'
      cargs << "--with-abi=64"
    else
      ENV.append 'CFLAGS', '-m32'
      cargs << "--with-abi=32"
    end

    if ARGV.include? '--with-machine-code'
    else
      cargs << "--without-machine-code"
    end

    ENV.j1

    system "make", "CONFIGUREARGS='" + cargs.join(' ') + "'"

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

   bin.install_symlink "#{libexec}/bin/pike" => "pike"
   share.install_symlink "#{libexec}/share/man" => "man"

  end

  def caveats
    s = <<-EOS.undent
    Pike has been installed into #{prefix}.

    EOS

    if @linked then

    s << <<-EOS.undent
    The pike interpreter has been linked into #{HOMEBREW_PREFIX}/bin.

    To get started, run:

    #{HOMEBREW_PREFIX}/bin/pike

    Enjoy!
    EOS
    end

    return s
  end
end
