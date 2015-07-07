class Paperkey < Formula
  desc "Extract just secret information out of OpenPGP secret keys"
  homepage "http://www.jabberwocky.com/software/paperkey/"
  url "http://www.jabberwocky.com/software/paperkey/paperkey-1.3.tar.gz"
  sha256 "5b57d7522336fb65c4c398eec27bf44ec0aaa35926157b79a76423231792cbfb"

  bottle do
    cellar :any
    sha256 "7ed27ec6a3f638446958eab7e408a0a3080c814affb36fb9f13cde515bb2c27f" => :yosemite
    sha256 "3e8b11e1c638df114045da58e0fdda7fbe5083a88f575c659cc11ac602d8fc11" => :mavericks
    sha256 "c1fb5b29d648f9fc0769a94cedc5e80af7c8edbd3c3702464fe02653cbb6da7a" => :mountain_lion
  end

  resource "secret.gpg" do
    url "https://gist.github.com/bfontaine/5b0e3efa97e2dc42a970/raw/915e802578339ddde2967de541ed65cb76cd14b9/secret.gpg"
    sha256 "eec8f32a401d1077feb19ea4b8e1816feeac02b9bfe6bd09e75c9985ff740890"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    resource("secret.gpg").stage do
      system "#{bin}/paperkey", "--secret-key", "secret.gpg", "--output", "test"
      assert File.exist? "test"
    end
  end
end
