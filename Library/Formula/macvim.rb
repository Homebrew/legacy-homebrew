require 'formula'

class Macvim <Formula
  url 'https://github.com/b4winckler/macvim/tarball/v7.3-53'
  version 'v7.3-53'
  md5 '35fb942c45109a2cbdbe7c1a3e02d59d'
  head 'git://github.com/b4winckler/macvim.git', :branch => 'master'
  homepage 'http://code.google.com/p/macvim/'

  def options
  [
    # Building custom icons fails for many users, so off by default.
    ["--custom-icons", "Try to generate custom document icons."],
    ["--with-cscope", "Build with Cscope support."],
    ["--with-envycoder", "Build with Envy Code R Bold font."]
  ]
  end

  depends_on 'cscope' if ARGV.include? '--with-cscope'

  def install
    if "4.0" == xcode_version
      opoo "MacVim may not compile under the Xcode 4 preview."
    end

    # MacVim's Xcode project gets confused by $CC
    # Disable it until someone figures out why it fails.
    ENV['CC'] = nil
    ENV['CFLAGS'] = nil
    ENV['CXX'] = nil
    ENV['CXXFLAGS'] = nil

    args = ["--with-macsdk=#{MACOS_VERSION}",
           # Add some features
           "--with-features=huge",
           "--enable-perlinterp",
           "--enable-pythoninterp",
           "--enable-rubyinterp",
           "--enable-tclinterp"]

    if ARGV.include? "--with-cscope"
      args << "--enable-cscope"
    end

    system "./configure", *args

    unless ARGV.include? "--custom-icons"
      inreplace "src/MacVim/icons/Makefile", "$(MAKE) -C makeicns", ""
      inreplace "src/MacVim/icons/make_icons.py", "dont_create = False", "dont_create = True"
    end

    unless ARGV.include? "--with-envycoder"
      inreplace "src/MacVim/icons/Makefile", '$(OUTDIR)/MacVim-generic.icns: make_icons.py vim-noshadow-512.png loadfont.so Envy\ Code\ R\ Bold.ttf',
                                             "$(OUTDIR)/MacVim-generic.icns: make_icons.py vim-noshadow-512.png loadfont.so"
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
