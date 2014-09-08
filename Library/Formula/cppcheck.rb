require "formula"

class Cppcheck < Formula
  homepage "http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page"
  url "https://github.com/danmar/cppcheck/archive/1.66.tar.gz"
  sha1 "277a214aa8a2bf30180645aca09c1dc9d3069977"

  head "https://github.com/danmar/cppcheck.git"

  bottle do
    sha1 "a3b2341260ab7afbb08dbf44e51b32d2edbd6d7c" => :mavericks
    sha1 "e7290d70f4aee90d644898785eb4eff25fbbcd8b" => :mountain_lion
    sha1 "ee30f858617e11e68d465d7406f445cf13d6f791" => :lion
  end

  option "no-rules", "Build without rules (no pcre dependency)"
  option "with-gui", "Build the cppcheck gui (requires Qt)"

  depends_on "pcre" unless build.include? "no-rules"
  depends_on "qt" if build.with? "gui"

  def install
    # Man pages aren't installed as they require docbook schemas.

    # Pass to make variables.
    if build.include? "no-rules"
      system "make", "HAVE_RULES=no", "CFGDIR=#{prefix}/cfg"
    else
      system "make", "HAVE_RULES=yes", "CFGDIR=#{prefix}/cfg"
    end

    system "make", "DESTDIR=#{prefix}", "BIN=#{bin}", "CFGDIR=#{prefix}/cfg", "install"

    if build.with? "gui"
      cd "gui" do
        # fix make not finding cfg directory:
        # https://github.com/Homebrew/homebrew/issues/27756
        inreplace "gui.qrc", "../cfg/", "#{prefix}/cfg/"

        if build.include? "no-rules"
          system "qmake", "HAVE_RULES=no"
        else
          system "qmake"
        end

        system "make"
        bin.install "cppcheck-gui.app"
      end
    end
  end

  test do
    system "#{bin}/cppcheck", "--version"
  end
end
