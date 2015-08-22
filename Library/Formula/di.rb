class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "http://www.gentoo.com/di/"
  url "http://gentoo.com/di/di-4.36.tar.gz"
  sha256 "eb03d2ac0a3df531cdcb64b3667dbaebede60a4d3a4626393639cecb954c6d86"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
