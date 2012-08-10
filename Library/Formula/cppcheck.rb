require 'formula'

class Cppcheck < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page'
  url 'https://github.com/danmar/cppcheck/tarball/1.55'
  sha1 '5a888427b9303420a1a583a2cb3919fb5ba3c5ce'

  head 'https://github.com/danmar/cppcheck.git'

  depends_on 'pcre' unless ARGV.include? '--no-rules'
  depends_on 'qt' if ARGV.include? '--with-gui'

  def options
    [
      ['--no-rules', "Build without rules (no pcre dependency)"],
      ['--with-gui', "Build the cppcheck gui."]
    ]
  end

  # Do not strip binaries, or else it fails to run.
  skip_clean :all

  def install
    # Man pages aren't installed as they require docbook schemas.

    # Pass to make variables.
    if ARGV.include? '--no-rules'
      system "make", "HAVE_RULES=no"
    else
      system "make"
    end

    system "make", "DESTDIR=#{prefix}", "BIN=#{bin}", "install"

    if ARGV.include? '--with-gui'
      cd "gui" do
        if ARGV.include? '--no-rules'
          system "qmake", "HAVE_RULES=no"
        else
          system "qmake"
        end

        system "make"
        bin.install "cppcheck-gui.app"
      end
    end
  end

  def caveats; <<-EOS.undent
    --with-gui installs cppcheck-gui.app in:
      #{bin}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{bin}/cppcheck-gui.app /Applications
    EOS
  end
end
