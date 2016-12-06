require 'formula'

class Pike < Formula
  homepage 'http://pike.ida.liu.se'
  url 'http://pike.ida.liu.se/pub/pike/beta/7.8.700/Pike-v7.8.700.tar.gz'
  sha1 '877bd50d2bb202aa485d1f7c62398922d60696c7'
  version '7.8.700'
  
  linked = 0

  depends_on :x11
  depends_on 'nettle'
  depends_on 'gmp'
  depends_on 'libtiff'
  depends_on 'libxml2'
  depends_on 'jpeg'
  depends_on 'freetype'
  depends_on 'gettext' if ARGV.include? '--with-gettext' or ARGV.include? '--with-all'
  depends_on 'gdbm' if ARGV.include? '--with-gdbm' or ARGV.include? '--with-all'
  depends_on 'gtk+' if ARGV.include? '--with-gtk2' or ARGV.include? '--with-all'
  depends_on 'mysql' if ARGV.include? '--with-mysql' or ARGV.include? '--with-all'
  depends_on 'pcre' if ARGV.include? '--with-pcre' or ARGV.include? '--with-all'
  depends_on 'sdl' if ARGV.include? '--with-sdl' or ARGV.include? '--with-all'
  depends_on 'sane-backends' if ARGV.include? '--with-sane' or ARGV.include? '--with-all'
  depends_on 'pdflib-lite' if ARGV.include? '--with-pdf' or ARGV.include? '--with-all'
  depends_on 'mesalib-glw' if ARGV.include? '--with-gl' or ARGV.include? '--with-all'
  
  fails_with :llvm do
    build 2335
    cause <<-EOS.undent
      Fails to build multiset.c, results in a Abort trap being caught.
      EOS
  end
  
  keg_only "This formula will install pike binary itself."

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
     ['--without-machine-code', 'Disabled maschine code'],
     ['--without-bundles', 'Disabled bundles']
   ]
  end

  def install
    cargs = [
        "--prefix=#{prefix}"
       ]
       
       if ARGV.include? '--without-machine-code'
         cargs << "--without-machine-code"
       end
         
       if ARGV.include? '--without-bundles'
           cargs << "--without-bundles"
       end
       
       if MacOS.prefer_64_bit? and not ARGV.build_32_bit?
         ENV.append 'CFLAGS', '-m64'
         cargs << "--with-abi=64"
       else
         ENV.append 'CFLAGS', '-m32'
         cargs << "--with-abi=32"
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
    # because there's no way to overried the keg.link command, this formula is
    # keg_only, and we symlink the pike binary to bin/ ourselves.
    system "make",  "install",
                    "prefix=#{prefix}",
                    "exec_prefix=#{prefix}",
                    "share_prefix=#{share}",
                    "lib_prefix=#{lib}",
                    "man_prefix=#{man}",
                    "include_path=#{include}", 
                    "INSTALLARGS=--traditional"

    bindir = "#{HOMEBREW_PREFIX}/bin"
    if File.exist? "#{HOMEBREW_PREFIX}/bin/pike" then
      ohai "Removing existing link for pike binary at #{HOMEBREW_PREFIX}/bin/pike."
    end

    ln_sf bin + "pike", "#{HOMEBREW_PREFIX}/bin/pike"
    @linked = 1

    if File.exist? "#{HOMEBREW_PREFIX}/share/man/man1/pike.1" then
      ohai "Removing existing link for pike man page at #{HOMEBREW_PREFIX}/share/man/man1/pike.1."
    end

    mkdir_p "#{HOMEBREW_PREFIX}/share/man/man1/"
    ln_sf share + "man/man1/pike.1", "#{HOMEBREW_PREFIX}/share/man/man1/pike.1"


  end

  def test
    system "make verify"
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