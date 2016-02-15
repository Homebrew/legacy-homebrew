class Aap < Formula
  desc "make-like tool to download, build, and install software"
  homepage "http://www.a-a-p.org"
  url "https://downloads.sourceforge.net/project/a-a-p/aap-1.094.zip"
  sha256 "3f53b2fc277756042449416150acc477f29de93692944f8a77e8cef285a1efd8"

  bottle do
    sha256 "b95b0d83504a5ec5c0d10143f2f85aa9fa21f394fda2cf14bebee8b1b643dd37" => :yosemite
    sha256 "019cb29542a8d8250e22cc10e389d1a2159a9db99db90dc9392650b288025507" => :mavericks
    sha256 "e496122256798dc62cd02ffdd0d72c7a1d682243c6743b1b7b0b88fc6b3bd34a" => :mountain_lion
  end

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
