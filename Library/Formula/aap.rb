class Aap < Formula
  desc "Aap is a make-like tool to download, build, and install software"
  homepage "http://www.a-a-p.org"
  url "https://downloads.sourceforge.net/project/a-a-p/Aap/1.093/aap-1.093.zip"
  sha256 "7a6c6c4a819a8379e60c679fe0c3f93eb1b74204cd7cc1c158263f4b34943001"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Aap only installs "man" at top level. This moves it under share/,
    # which OS X and Homebrew use by default.
    # Upstream bug report: http://sourceforge.net/p/a-a-p/mailman/message/34146703/
    inreplace "main.aap", "mandir = $PREFIX/man/man1", "mandir = $PREFIX/share/man/man1"

    # Aap is designed to install using itself
    system "./aap", "install", "PREFIX=#{prefix}"
  end

  test do
    # A dummy target definition
    (testpath/"main.aap").write("dummy:\n\t:print OK\n")
    system "#{bin}/aap", "dummy"
  end
end
