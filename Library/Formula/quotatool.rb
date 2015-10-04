class Quotatool < Formula
  desc "Edit disk quotas from the command-line"
  homepage "http://quotatool.ekenberg.se"
  url "http://quotatool.ekenberg.se/quotatool-1.6.2.tar.gz"
  sha256 "e53adc480d54ae873d160dc0e88d78095f95d9131e528749fd982245513ea090"

  bottle do
    cellar :any
    sha256 "8af3549d42247f0b79458c96978f8f5e5fbe04cc1c0dd86f84accdf03e8e510f" => :yosemite
    sha256 "724a3fc561188de5e0e050f7459480cc8c613d399faee5290ec7a68b9715960d" => :mavericks
    sha256 "29271c3bc97b9623264fe2f67e821f1810442f11b15ad1b7f231472905d078e4" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    sbin.mkpath
    man8.mkpath
    system "make", "install"
  end

  test do
    system "#{sbin}/quotatool", "-V"
  end
end
