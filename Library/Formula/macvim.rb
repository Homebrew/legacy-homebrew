require 'formula'

class Macvim <Formula
  url 'https://github.com/b4winckler/macvim/tarball/v7.3-53'
  version 'v7.3-53'
  md5 '35fb942c45109a2cbdbe7c1a3e02d59d'
  head 'git://github.com/b4winckler/macvim.git', :branch => 'master'
  homepage 'http://code.google.com/p/macvim/'

  def options
    # Occassional reports of this brew failing during the icon step
    [["--no-icons", "Don't generate custom document icons."]]
  end

  def install
    # MacVim's Xcode project gets confused by $CC
    # Disable it until someone figures out why it fails.
    ENV['CC'] = nil
    ENV['CFLAGS'] = nil
    ENV['CXX'] = nil
    ENV['CXXFLAGS'] = nil

    system "./configure",
           "--with-macsdk=#{MACOS_VERSION}",
           # Add some features
           "--with-features=huge",
           "--enable-perlinterp",
           "--enable-pythoninterp",
           "--enable-rubyinterp",
           "--enable-tclinterp"

    if ARGV.include? "--no-icons"
      inreplace "src/MacVim/icons/Makefile", "$(MAKE) -C makeicns", ""
      inreplace "src/MacVim/icons/make_icons.py", "dont_create = False", "dont_create = True"
    end

    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    inreplace "src/MacVim/mvim", /^# VIM_APP_DIR=\/Applications$/,
              "VIM_APP_DIR=#{prefix}"
    bin.install "src/MacVim/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    %w[mvimdiff mview mvimex].each {|f| ln_s bin+'mvim', bin+f}
  end

  def caveats
    "MacVim.app installed to:\n#{prefix}"
  end
end
