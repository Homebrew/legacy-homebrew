class Paperkey < Formula
  homepage "http://www.jabberwocky.com/software/paperkey/"
  url "http://www.jabberwocky.com/software/paperkey/paperkey-1.3.tar.gz"
  sha256 "5b57d7522336fb65c4c398eec27bf44ec0aaa35926157b79a76423231792cbfb"

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
