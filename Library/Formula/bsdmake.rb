class Bsdmake < Formula
  desc "BSD make (build tool)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/bsdmake/bsdmake-24.tar.gz"
  sha256 "82a948b80c2abfc61c4aa5c1da775986418a8e8eb3dd896288cfadf2e19c4985"

  bottle do
    revision 1
    sha256 "b4052277ac6cf79ed579107fb73da96954c350d7bf29a124c55d87a0df8940b0" => :el_capitan
    sha256 "18d7cb56f14eb2e404cf3abb163a354f57c5e45b72991efdd6566a15fcffe90f" => :yosemite
    sha256 "5807a64aab8f81720718a4327d303d7955a09739b079aefd72a4f216519f0de7" => :mavericks
    sha256 "7f64345157a82d82163606a09839619ec2ffc174242ceb942c2347526fee4f83" => :mountain_lion
  end

  keg_only :provided_until_xcode43

  # MacPorts patches to make bsdmake play nice with our prefix system
  # Also a MacPorts patch to circumvent setrlimit error
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/1fcaddfc/bsdmake/patch-Makefile.diff"
    sha256 "1e247cb7d8769d50e675e3f66b6f19a1bc7663a7c0800fc29a2489f3f6397242"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/1fcaddfc/bsdmake/patch-mk.diff"
    sha256 "b7146bfe7a28fc422e740e28e56e5bf0166a29ddf47a54632ad106bca2d72559"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/1fcaddfc/bsdmake/patch-pathnames.diff"
    sha256 "b24d73e5fe48ac2ecdfbe381e9173f97523eed5b82a78c69dcdf6ce936706ec6"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/1fcaddfc/bsdmake/patch-setrlimit.diff"
    sha256 "cab53527564d775d9bd9a6e4969f116fdd85bcf0ad3f3e57ec2dcc648f7ed448"
  end

  def install
    # Replace @PREFIX@ inserted by MacPorts patches
    # Use "prefix" since this is sometimes a keg-only brew
    # But first replace the X11 path if X11 is installed
    inreplace "mk/sys.mk", "@PREFIX@", MacOS::X11.prefix || prefix
    inreplace %W[mk/bsd.README
                 mk/bsd.cpu.mk
                 mk/bsd.doc.mk
                 mk/bsd.obj.mk
                 mk/bsd.own.mk
                 mk/bsd.port.mk
                 mk/bsd.port.subdir.mk
                 pathnames.h],
                 "@PREFIX@", prefix

    inreplace "mk/bsd.own.mk" do |s|
      s.gsub! "@INSTALL_USER@", `id -un`.chomp
      s.gsub! "@INSTALL_GROUP@", `id -gn`.chomp
    end

    # See GNUMakefile
    ENV.append "CFLAGS", "-D__FBSDID=__RCSID"
    ENV.append "CFLAGS", "-mdynamic-no-pic"

    system "make", "-f", "Makefile.dist"
    bin.install "pmake" => "bsdmake"
    man1.install "make.1" => "bsdmake.1"
    (share/"mk/bsdmake").install Dir["mk/*"]
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      foo:
      \ttouch $@
    EOS

    system "#{bin}/bsdmake"
    assert File.exist? "#{testpath}/foo"
  end
end
