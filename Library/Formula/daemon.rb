class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "http://libslack.org/daemon/"
  url "http://libslack.org/daemon/download/daemon-0.6.4.tar.gz"
  sha256 "c4b9ea4aa74d55ea618c34f1e02c080ddf368549037cb239ee60c83191035ca1"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad4f8ad9e7deeb0039c6c603b0108fb6733abe425c49fa6344f762e26b49cf2d" => :el_capitan
    sha256 "f48000af3631f28d47d01d3d89a1f03e7c4f7eac4a81ab7db9c38a1ce9ff66cd" => :yosemite
    sha256 "09a420b59d2e5cbaf3073b2daf81d57d01c733b79a928bb58da6418de7f5bd3a" => :mavericks
  end

  # fixes for mavericks strlcpy/strlcat: https://trac.macports.org/ticket/42845
  if MacOS.version >= :mavericks
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/3323958/daemon/daemon-0.6.4-ignore-strlcpy-strlcat.patch"
      sha256 "a56e16b0801a13045d388ce7e755b2b4e40288c3731ce0f92ea879d0871782c0"
    end
  end

  def install
    # Parallel build failure reported to raf@raf.org 27th Feb 2016
    ENV.deparallelize

    system "./config"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
