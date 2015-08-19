class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "http://ftpmirror.gnu.org/automake/automake-1.15.tar.xz"
  mirror "https://ftp.gnu.org/gnu/automake/automake-1.15.tar.xz"
  sha256 "9908c75aabd49d13661d6dcb1bc382252d22cc77bf733a2d55e87f2aa2db8636"

  bottle do
    sha1 "493f0b3b591fd72412d0b048539df4d94127ec9c" => :yosemite
    sha1 "a50e536f4cb8b7c45d51ab44fbc0825866553268" => :mavericks
    sha1 "9430f3bca0176048b418440e57ca6b9d6773fc31" => :mountain_lion
  end

  depends_on "autoconf" => :run

  keg_only :provided_until_xcode43

  def install
    ENV["PERL"] = "/usr/bin/perl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<-EOS.undent
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    system "#{bin}/automake", "--version"
  end
end
