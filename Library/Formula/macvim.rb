require 'formula'

class Macvim < Formula
  homepage 'http://code.google.com/p/macvim/'
  url 'https://github.com/b4winckler/macvim/tarball/snapshot-64'
  version '7.3-64'
  md5 '5bdc0bc618b3179130f846f8d0f81283'

  head 'https://github.com/b4winckler/macvim.git', :branch => 'master'

  def options
  [
    ["--with-cscope", "Build with Cscope support."],
    ["--override-system-vim", "Override system vim."],
  ]
  end

  depends_on 'cscope' if ARGV.include? '--with-cscope'

  def patches
    # fixes warnings during build for makeicns on OS X 10.5
    "https://github.com/xoob/macvim/commit/feb69a3354d3e5f24a3d2fecbb559de635b83fa0.patch"
  end

  def install
    # MacVim's Xcode project gets confused by $CC, so remove it
    ENV['CC'] = nil
    ENV['CFLAGS'] = nil
    ENV['CXX'] = nil
    ENV['CXXFLAGS'] = nil

    # Set ARCHFLAGS so the Python app (with C extension) that is
    # used to create the custom icons will not try to compile in
    # PPC support (which isn't needed in Homebrew-supported systems.)
    arch = MacOS.prefer_64_bit? ? 'x86_64' : 'i386'
    ENV['ARCHFLAGS'] = "-arch #{arch}"

    args = ["--with-features=huge",
            "--with-tlib=ncurses",
            "--enable-multibyte",
            "--with-macarchs=#{arch}",
            "--enable-perlinterp",
            "--enable-pythoninterp",
            "--enable-rubyinterp",
            "--enable-tclinterp"]

    args << "--enable-cscope" if ARGV.include? "--with-cscope"

    system "./configure", *args

    # Build custom document icons
    # Reference: https://github.com/b4winckler/macvim/wiki/building
    cd "src/MacVim/icons" do
      system "make -i getenvy"
      system "make all"
    end

    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    inreplace "src/MacVim/mvim", /^# VIM_APP_DIR=\/Applications$/,
              "VIM_APP_DIR=#{prefix}"
    bin.install "src/MacVim/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex]
    executables += %w[vi vim vimdiff view vimex] if ARGV.include? "--override-system-vim"
    executables.each {|f| ln_s bin+'mvim', bin+f}
  end

  def caveats; <<-EOS.undent
    MacVim.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{prefix}/MacVim.app /Applications
    EOS
  end
end
