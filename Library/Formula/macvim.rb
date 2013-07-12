require 'formula'

# Reference: https://github.com/b4winckler/macvim/wiki/building
class Macvim < Formula
  homepage 'http://code.google.com/p/macvim/'
  url 'https://github.com/b4winckler/macvim/archive/snapshot-66.tar.gz'
  version '7.3-66'
  sha1 'd2915438c9405015e5e39099aecbbda20438ce81'

  devel do
    url 'https://github.com/b4winckler/macvim/archive/snapshot-67.tar.gz'
    version '7.4a-BETA-67'
    sha1 '7404747fbc1db9c8a8717ccdb1a04d365da498e6'
  end

  head 'https://github.com/b4winckler/macvim.git', :branch => 'master'

  option "custom-icons", "Try to generate custom document icons"
  option "override-system-vim", "Override system vim"

  depends_on :xcode
  depends_on 'cscope' => :recommended
  depends_on 'lua' => :optional
  depends_on :python => :recommended
  # Help us! :python3 in MacVim makes the window disappear, so only 2.x bindings!

  def install
    # Set ARCHFLAGS so the Python app (with C extension) that is
    # used to create the custom icons will not try to compile in
    # PPC support (which isn't needed in Homebrew-supported systems.)
    arch = MacOS.prefer_64_bit? ? 'x86_64' : 'i386'
    ENV['ARCHFLAGS'] = "-arch #{arch}"

    # If building for 10.7 or up, make sure that CC is set to "clang".
    ENV.clang if MacOS.version >= :lion

    args = %W[
      --with-features=huge
      --enable-multibyte
      --with-macarchs=#{arch}
      --enable-perlinterp
      --enable-rubyinterp
      --enable-tclinterp
      --with-ruby-command=#{RUBY_PATH}
      --with-tlib=ncurses
      --with-compiledby=Homebrew
      --with-local-dir=#{HOMEBREW_PREFIX}
    ]

    args << "--with-macsdk=#{MacOS.version}" unless MacOS::CLT.installed?
    args << "--enable-cscope" if build.with? "cscope"

    if build.with? "lua"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{HOMEBREW_PREFIX}"
    end

    args << "--enable-pythoninterp=yes" if build.with? 'python'

    # MacVim seems to link Python by `-framework Python` (instead of
    # `python-config --ldflags`) and so we have to pass the -F to point to
    # where the Python.framework is located, we want it to use!
    # Also the -L is needed for the correct linking. This is a mess but we have
    # to wait until MacVim is really able to link against different Python's
    # on the Mac. Note configure detects brewed python correctly, but that
    # is ignored.
    # See https://github.com/mxcl/homebrew/issues/17908
    ENV.prepend 'LDFLAGS', "-L#{python2.libdir} -F#{python2.framework}" if python && python.brewed?

    unless MacOS::CLT.installed?
      # On Xcode-only systems:
      # Macvim cannot deal with "/Applications/Xcode.app/Contents/Developer" as
      # it is returned by `xcode-select -print-path` and already set by
      # Homebrew (in superenv). Instead Macvim needs the deeper dir to directly
      # append "SDKs/...".
      args << "--with-developer-dir=#{MacOS::Xcode.prefix}/Platforms/MacOSX.platform/Developer/"
    end

    system "./configure", *args

    if build.include? "custom-icons"
      # Get the custom font used by the icons
      cd 'src/MacVim/icons' do
        system "make getenvy"
      end
    else
      # Building custom icons fails for many users, so off by default.
      inreplace "src/MacVim/icons/Makefile", "$(MAKE) -C makeicns", ""
      inreplace "src/MacVim/icons/make_icons.py", "dont_create = False", "dont_create = True"
    end

    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    inreplace "src/MacVim/mvim", /^# VIM_APP_DIR=\/Applications$/,
                                 "VIM_APP_DIR=#{prefix}"
    bin.install "src/MacVim/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex] if build.include? "override-system-vim"
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
