require "formula"

class Cppcheck < Formula
  homepage "http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page"
  url "https://github.com/danmar/cppcheck/archive/1.67.tar.gz"
  sha1 "14b886e5cac631cec11a3f8efbdeaed15ddcc7d3"
  revision 1

  head "https://github.com/danmar/cppcheck.git"

  bottle do
    sha1 "f5be9595dfdbbc616cbd1f11d3ea59ec32045309" => :yosemite
    sha1 "5fb0911b3ff750368cbbfed71a1809e298404d8b" => :mavericks
    sha1 "ae6b9a60ed3e139814c647aabdb4df1c71058436" => :mountain_lion
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

    # make sure cppcheck can find its configure directory, #26194
    prefix.install "cfg"

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
