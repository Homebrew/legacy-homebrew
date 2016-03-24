class Lrzsz < Formula
  desc "Tools for zmodem/xmodem/ymodem file transfer"
  # Homepage and URL redirect http to https, which is great.
  # Less great: Upstream SSL cert expired Dec 2015 and now fails to download.
  homepage "http://www.ohse.de/uwe/software/lrzsz.html"
  # url "http://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz"
  url "https://dl.bintray.com/homebrew/mirror/lrzsz-0.12.20.tar.gz"
  sha256 "c28b36b14bddb014d9e9c97c52459852f97bd405f89113f30bee45ed92728ff1"

  bottle do
    sha256 "578641aa80e798cfea91cd20b1d6f0b6a3190f2656dc81e3ccc24caadcf1c3b2" => :el_capitan
    sha256 "c417cab543224228762023031d93f2b4acfe0f970ed3ea1cc6616893e83cad6b" => :yosemite
    sha256 "2644d211f486bbc5e67094d80454025a53e9dbda37154e9161f6a5908958788c" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    # there's a bug in lrzsz when using custom --prefix
    # must install the binaries manually first
    bin.install "src/lrz", "src/lsz"

    system "make", "install"
    bin.install_symlink "lrz" => "rz", "lsz" => "sz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lrb --help 2>&1")
  end
end
