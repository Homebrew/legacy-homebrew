class When < Formula
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://mirrors.kernel.org/debian/pool/main/w/when/when_1.1.34.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/when/when_1.1.34.orig.tar.gz"
  sha256 "ce0540bde96b361d6d0770803901364a687d971ffedd33e36f8f8bef32b19600"
  head "https://github.com/bcrowell/when.git"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    temp_home = Pathname(ENV["HOME"])
    (temp_home/".when/preferences").write <<-EOS.undent
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
