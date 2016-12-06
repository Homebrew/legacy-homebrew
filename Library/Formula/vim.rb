# original in gist https://gist.github.com/838588 
# Thanks to @MindTooth

require 'formula'

class Vim < Formula
  url 'ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2'
  homepage 'http://www.vim.org/'
  md5 '5b9510a17074e2b37d8bb38ae09edbf2'
  version '7.3.125'

  def patchlevel; 125 end
  def features; %w(tiny small normal big huge) end
  def interp; %w(lua mzscheme perl python python3 tcl ruby) end

  def options
    features.map {|f| ["--#{f}", "Configure with --with-feature-#{f}"] } \
    | interp.map {|i| ["--#{i}", "Configure with --enable-#{i}interp"] }
  end

  def patches
    patches = (1..patchlevel).map {|i| sprintf('ftp://ftp.vim.org/pub/vim/patches/7.3/7.3.%03d', i) }
    {:p0 => patches}
  end

  def install
    feature = features.find {|f| ARGV.include? "--#{f}" } || "normal"
    opts = []
    interp.each do |i|
      opts << "--enable-#{i}interp=yes" if ARGV.include? "--#{i}"
    end
    system "./configure",
      "--disable-gui",
      "--without-x",
      "--disable-gpm",
      "--disable-nls",
      "--with-tlib=ncurses",
      "--enable-multibyte",
      "--with-feature-#{feature}",
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      *opts
    system "make install"
  end
end