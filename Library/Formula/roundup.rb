class Roundup < Formula
  desc "Unit testing tool"
  homepage "https://bmizerany.github.io/roundup"
  url "https://github.com/bmizerany/roundup/archive/v0.0.5.tar.gz"
  sha256 "f23397ab2a219508a7e6ccc6b40e0b1627fc4e8d25f68c4fe26316a644118e4f"

  head "https://github.com/bmizerany/roundup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54fd2eea633548d627df8cd4cc3962c5ca3521c7d8c69c9e76018749ed1c8614" => :el_capitan
    sha256 "86362d0a78da1dcb29dc1a421161446d6664feba9ad6be2f8392ad64daf0978d" => :yosemite
    sha256 "ba15d496c1d2be929e477488d4917748b3652d4fb82703388228fd37992249c8" => :mavericks
  end

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
