class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "http://ftpmirror.gnu.org/emacs/emacs-24.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.xz"
  sha256 "dd47d71dd2a526cf6b47cb49af793ec2e26af69a0951cc40e43ae290eacfc34e"

  bottle do
    sha256 "01d4fcc1d234b191849cd10524cd4a987786ee533af5e8b94cbfb1f25387973e" => :yosemite
    sha256 "db50780fe2e249d68f353d3c1b80aef80d265cb4a726d2e224bfaad1e8632cb7" => :mavericks
    sha256 "fc28dc93d42840b5483804a68de12a0840c7f78495be79f3912e4e41ae1d1455" => :mountain_lion
  end

  devel do
    url "http://git.sv.gnu.org/r/emacs.git", :branch => "emacs-24"
    version "24.5-dev"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  head do
    url "http://git.sv.gnu.org/r/emacs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-cocoa", "Build a Cocoa version of emacs"
  option "with-ctags", "Don't remove the ctags executable that emacs provides"

  deprecated_option "cocoa" => "with-cocoa"
  deprecated_option "keep-ctags" => "with-ctags"
  deprecated_option "with-x" => "with-x11"

  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "d-bus" => :optional
  depends_on "gnutls" => :optional
  depends_on "librsvg" => :optional
  depends_on "imagemagick" => :optional
  depends_on "mailutils" => :optional
  depends_on "glib" => :optional

  # https://github.com/Homebrew/homebrew/issues/37803
  if build.with? "x11"
    depends_on "freetype" => :recommended
    depends_on "fontconfig" => :recommended
  end

  fails_with :llvm do
    build 2334
    cause "Duplicate symbol errors while linking."
  end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
            "--infodir=#{info}/emacs"]

    args << "--with-file-notification=gfile" if build.with? "glib"

    if build.with? "d-bus"
      args << "--with-dbus"
    else
      args << "--without-dbus"
    end

    if build.with? "gnutls"
      args << "--with-gnutls"
    else
      args << "--without-gnutls"
    end

    args << "--with-rsvg" if build.with? "librsvg"
    args << "--with-imagemagick" if build.with? "imagemagick"
    args << "--without-popmail" if build.with? "mailutils"

    system "./autogen.sh" if build.head? || build.devel?

    if build.with? "cocoa"
      args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *args
      system "make"
      system "make", "install"
      prefix.install "nextstep/Emacs.app"

      # Replace the symlink with one that avoids starting Cocoa.
      (bin/"emacs").unlink # Kill the existing symlink
      (bin/"emacs").write <<-EOS.undent
        #!/bin/bash
        exec #{prefix}/Emacs.app/Contents/MacOS/Emacs -nw  "$@"
      EOS
    else
      if build.with? "x11"
        # These libs are not specified in xft's .pc. See:
        # https://trac.macports.org/browser/trunk/dports/editors/emacs/Portfile#L74
        # https://github.com/Homebrew/homebrew/issues/8156
        ENV.append "LDFLAGS", "-lfreetype -lfontconfig"
        args << "--with-x"
        args << "--with-gif=no" << "--with-tiff=no" << "--with-jpeg=no"
      else
        args << "--without-x"
      end
      args << "--without-ns"

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    if build.without? "ctags"
      (bin/"ctags").unlink
      (man1/"ctags.1.gz").unlink
    end
  end

  def caveats
    if build.with? "cocoa" then <<-EOS.undent
      A command line wrapper for the cocoa app was installed to:
        #{bin}/emacs
      EOS
    end
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/emacs</string>
        <string>--daemon</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
