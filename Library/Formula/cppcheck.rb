require 'formula'

class Cppcheck < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page'
  url 'https://github.com/danmar/cppcheck/archive/1.63.1.tar.gz'
  sha1 '19ad7251603356a82dc75a836dfad9629a3d12a0'

  head 'https://github.com/danmar/cppcheck.git'

  option 'no-rules', "Build without rules (no pcre dependency)"
  option 'with-gui', "Build the cppcheck gui (requires Qt)"

  depends_on 'pcre' unless build.include? 'no-rules'
  depends_on 'qt' if build.include? 'with-gui'

  def install
    # Man pages aren't installed as they require docbook schemas.

    # Pass to make variables.
    if build.include? 'no-rules'
      system "make", "HAVE_RULES=no"
    else
      system "make", "HAVE_RULES=yes"
    end

    system "make", "DESTDIR=#{prefix}", "BIN=#{bin}", "install"

    if build.include? 'with-gui'
      cd "gui" do
        if build.include? 'no-rules'
          system "qmake", "HAVE_RULES=no"
        else
          system "qmake"
        end

        system "make"
        bin.install "cppcheck-gui.app"
      end
    end
  end

  def test
    system "#{bin}/cppcheck", "--version"
  end
end
