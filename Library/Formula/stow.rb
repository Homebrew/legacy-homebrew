class Stow < Formula
  homepage "https://www.gnu.org/software/stow/"
  url "http://ftpmirror.gnu.org/stow/stow-2.2.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/stow/stow-2.2.0.tar.gz"
  sha256 "8b89d79939cf9ae87d2f223bb36a3b2d0c66775b62aeb9953c6d33dab40d3c2b"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system "#{bin}/stow", "-nvS", "test"
  end
end
