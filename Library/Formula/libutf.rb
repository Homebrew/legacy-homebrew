class Libutf < Formula
  desc "Port of Plan 9's support library for UTF-8 and Unicode"
  homepage "http://swtch.com/plan9port/unix/"
  url "http://swtch.com/plan9port/unix/libutf-20110530.tgz"
  sha256 "7789326c507fe9c07ade0731e0b0da221385a8f7cd1faa890af92a78a953bf5e"

  bottle do
    cellar :any
    revision 1
    sha1 "ff7ca7a52c3c3cf376a8e751627fd23728f08e14" => :yosemite
    sha1 "ad54688e8da7c6d72aa85ec679a2f2b442ab5d7b" => :mavericks
    sha1 "3c5dac2740872a0583db363a103af74ffd6fb7cd" => :mountain_lion
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
