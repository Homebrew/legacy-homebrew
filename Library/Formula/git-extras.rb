class GitExtras < Formula
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/2.2.0.tar.gz"
  sha256 "6a933114d276761a078e653a961566d9517a6a4eaadacb62e655d39481548f63"

  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any
    sha1 "43d178ce9c98a28a6ce7cc337119bb500c0fddec" => :yosemite
    sha1 "85b967c0c3b2b7eae0af37d18b9b90bad08f79cc" => :mavericks
    sha1 "54df32fa640c8cd05616c8ebb5cbf1ec8cc95565" => :mountain_lion
  end

  def install
    inreplace "Makefile", %r{\$\(DESTDIR\)(?=/etc/bash_completion\.d)}, "$(DESTDIR)$(PREFIX)"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    cd HOMEBREW_PREFIX do
      system "#{bin}/git-root"
    end
  end
end
