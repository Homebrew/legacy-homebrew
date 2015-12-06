class Vmtouch < Formula
  desc "Portable file system cache diagnostics and control"
  homepage "http://hoytech.com/vmtouch"
  url "https://github.com/hoytech/vmtouch/archive/vmtouch-1.0.2.tar.gz"
  sha256 "48d41e5b805a0fcac46c12feeb4650e4b9def44b75d528d7c66c2f8b3a747c39"
  head "https://github.com/hoytech/vmtouch.git"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system "#{bin}/vmtouch", "#{bin}/vmtouch"
  end
end
