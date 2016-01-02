class Libutf < Formula
  desc "Port of Plan 9's support library for UTF-8 and Unicode"
  homepage "https://swtch.com/plan9port/unix/"
  url "https://swtch.com/plan9port/unix/libutf-20110530.tgz"
  sha256 "7789326c507fe9c07ade0731e0b0da221385a8f7cd1faa890af92a78a953bf5e"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "4be39969572bec265a41d1ff6bc8f6d04b6d2b4f514cfd58c3362bc3434b3807" => :el_capitan
    sha256 "db18dd0a20318d3f07f2eb195cb6ec345976136d5d2eddfb71c3e426fe4c1162" => :yosemite
    sha256 "36a420b96d2d8bebc33a10edfce866c576664a8001136e4440609138b892db30" => :mavericks
  end

  def install
    # Make.Darwin-386 is the only Makefile they have
    inreplace "Makefile" do |f|
      f.gsub! "man/man7", "share/man/man7"
      f.gsub! "Make.$(SYSNAME)-$(OBJTYPE)", "Make.Darwin-386"
    end
    system "make", "PREFIX=#{prefix}", "install"
  end
end
