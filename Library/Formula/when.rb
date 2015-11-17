class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://mirrors.kernel.org/debian/pool/main/w/when/when_1.1.34.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/when/when_1.1.34.orig.tar.gz"
  sha256 "ce0540bde96b361d6d0770803901364a687d971ffedd33e36f8f8bef32b19600"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any
    sha256 "2cabf7cbe84effcefcba892ba5008e5fbd6f1558cdf967fbc9ce09d2f3dea6d3" => :yosemite
    sha256 "b4724a057c7078514306e334e16ff242a2085adf09a2c41c5228e211d43a7729" => :mavericks
    sha256 "2bb76c69919b847c94ecd3600908848e989d93e5c5a3b949410cad73c376a2f5" => :mountain_lion
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<-EOS.undent
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
