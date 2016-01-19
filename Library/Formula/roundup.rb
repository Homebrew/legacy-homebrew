class Roundup < Formula
  desc "Issue-tracking system"
  homepage "https://bmizerany.github.io/roundup"
  url "https://github.com/bmizerany/roundup/archive/v0.0.5.tar.gz"
  sha256 "f23397ab2a219508a7e6ccc6b40e0b1627fc4e8d25f68c4fe26316a644118e4f"

  head "https://github.com/bmizerany/roundup.git"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          "--datarootdir=#{share}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/roundup", "-v"
  end
end
