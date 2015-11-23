class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "http://ftpmirror.gnu.org/stow/stow-2.2.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/stow/stow-2.2.0.tar.gz"
  sha256 "8b89d79939cf9ae87d2f223bb36a3b2d0c66775b62aeb9953c6d33dab40d3c2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f216de55fde1bd78b1f67d43864827ac6620267347e5cfd30bf9b2c58d495d1" => :el_capitan
    sha256 "f11002df010f309124bc647fae96677a49f38bb7a79b21ecb2a6f143fd4c3133" => :yosemite
    sha256 "702e73f3b54a8d875cc41d74087a2c0beda2833829c5c87b995467ea12c29bba" => :mavericks
    sha256 "0ae633b4e9fb7e40b57466963a2777db6d95cc6490935eb70b47181dfae79d72" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system "#{bin}/stow", "-nvS", "test"
  end
end
