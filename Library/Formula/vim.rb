require 'formula'

class Vim <Formula
  @url='ftp://ftp.vim.org/pub/vim/unix/vim-7.2.tar.bz2'
  @homepage='http://www.vim.org/'
  @md5='f0901284b338e448bfd79ccca0041254'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          # don't version stuff in Homebrew, we already do that!
                          "--enable-fndir=#{share}/zsh/functions",
                          "--enable-scriptdir=#{share}/zsh/scripts",
                          "--with-features=huge",
                          "--enable-gui=no",
                          "--without-x",
                          "--enable-multibyte",
                          "--enable-pythoninterp"

    system "make install"
  end

  def patches
    # patch_groups = %w( 001-100 101-200 201-300 ).collect {|r| "http://mirrors.24-7-solutions.net/pub/vim/patches/7.2/7.2.#{r}.gz"}
    # individual_patches = 1.upto(15).collect {|num| "http://mirrors.24-7-solutions.net/pub/vim/patches/7.2/7.2.%03d" % num}
    # {
      # # :p0 => 1.upto(22).collect {|num| "http://opensource.apple.com/source/vim/vim-39/patches/7.2.%03d?f=text" % num}
      # # :p0 => 1.upto(22).collect {|num| "http://ftp.vim.org/pub/vim/patches/7.2/7.2.%03d" % num}
      # :p0 => (patch_groups | individual_patches)
    # }
  end
  
  def skip_clean? path
    true
  end
end
