class Aap < Formula
  desc "Aap is a make-like tool to download, build, and install software"
  homepage "http://www.a-a-p.org"
  url "https://downloads.sourceforge.net/project/a-a-p/aap-1.094.zip"
  sha256 "3f53b2fc277756042449416150acc477f29de93692944f8a77e8cef285a1efd8"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Aap is designed to install using itself
    system "./aap", "install", "PREFIX=#{prefix}", "MANSUBDIR=share/man"
  end

  test do
    # A dummy target definition
    (testpath/"main.aap").write("dummy:\n\t:print OK\n")
    system "#{bin}/aap", "dummy"
  end
end
