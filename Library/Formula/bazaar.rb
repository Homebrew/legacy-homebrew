class Bazaar < Formula
  desc "Human-friendly source code management (or 'version control')"
  homepage "http://bazaar.canonical.com/"
  url "https://launchpad.net/bzr/2.7/2.7.0/+download/bzr-2.7.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "ad25ac7aae3262bb674c9e2261415daecfaaf9b5d5f57ff14428be9409b895b8" => :el_capitan
    sha256 "29ff8d9c8fe3eee3a2a2172d5247970a68fa8d24c7516ae06bed9b3849259f2c" => :yosemite
    sha256 "cfda2b2e1b18687428c407155cb2e497563279d861120d0aa3f5a9e886cabf76" => :mavericks
    sha256 "7aa76616196f64b7a979708bb67703d9e70d4fe74bae55f204c9c844dfe71611" => :mountain_lion
  end

  def install
    ENV.j1 # Builds aren't parallel-safe

    # Make and install man page first
    system "make", "man1/bzr.1"
    man1.install "man1/bzr.1"

    # Put system Python first in path
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin"

    system "make"
    inreplace "bzr", "#! /usr/bin/env python", "#!/usr/bin/python"
    libexec.install "bzr", "bzrlib"

    (bin/"bzr").write_env_script(libexec/"bzr", :BZR_PLUGIN_PATH => "+user:#{HOMEBREW_PREFIX}/share/bazaar/plugins")
  end

  test do
    bzr = "#{bin}/bzr"
    whoami = "Homebrew"
    system bzr, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/bzr whoami")
    system bzr, "init-repo", "sample"
    system bzr, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bzr, "add", "test.txt"
      system bzr, "commit", "-m", "test"
    end
  end
end
