require 'formula'

class Macvim <Formula
  head 'git://repo.or.cz/MacVim.git'
  homepage 'http://code.google.com/p/macvim'

  def install
    # MacVim's Xcode project gets confused by $CC, disable it until someone
    # figures out why it fails.
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
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    inreplace "src/MacVim/mvim", /^# VIM_APP_DIR=\/Applications$/,
              "VIM_APP_DIR=#{prefix}"
    bin.install "src/MacVim/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    %w[mvimdiff mview mvimex].each do |f|
      (bin + f).make_symlink("#{bin}/mvim")
    end
  end

  def caveats
    "MacVim.app installed to #{prefix}."
  end
end
