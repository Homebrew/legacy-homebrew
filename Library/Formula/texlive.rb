require "formula"

class Texlive < Formula
  homepage "http://www.tug.org/texlive/"

  url "https://downloads.sourceforge.net/project/linuxbrew/mirror/texlive-20141204.tar.gz"
  mirror "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
  sha1 "bff2fd78c9c4c0818fe3d0c1c795813777d6a5d0"

  option "with-full", "install everything"
  option "with-medium", "install small + more packages and languages"
  option "with-small", "install basic + xetex, metapost, a few languages [default]"
  option "with-basic", "install plain and latex"
  option "with-minimal", "install plain only"

  def install
    scheme = %w[full medium small basic minimal].find {
      |x| build.with? x
    } || "small"

    ohai "Downloading and installing TeX Live. This will take a few minutes."
    ENV["TEXLIVE_INSTALL_PREFIX"] = prefix
    system "./install-tl", "-scheme", scheme, "-portable", "-profile", "/dev/null"

    binarch = bin/"x86_64-linux"
    man1.install Dir[binarch/"man/man1/*"]
    man5.install Dir[binarch/"man/man5/*"]
    bin.install_symlink Dir[binarch/"*"]
  end

  test do
    system "#{bin}/tex --version"
  end
end
