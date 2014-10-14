require "formula"

class Pex < Formula
  homepage "https://github.com/petere/pex"
  url "https://github.com/petere/pex/archive/1.20140409.tar.gz"
  sha1 "7cc652cd89bc6c6bf2488c8eb1ee91588053262a"

  depends_on :postgresql

  def install
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
  end

  def caveats; <<-EOS.undent
    If installing for the first time, perform the following in order to setup the necessary directory structure:
      pex init
    EOS
  end

  test do
    assert_match /share\/pex\/packages/, `pex --repo`.strip
  end
end
