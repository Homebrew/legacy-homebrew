class Cocot < Formula
  desc "Code converter on tty"
  homepage "http://vmi.jp/software/cygwin/cocot.html"
  url "https://github.com/vmi/cocot/archive/cocot-1.1-20120313.tar.gz"
  sha256 "bc67576b04a753c49ec563c30fb0cc383e9ce7a3db9295a384b7f77fcc1a57b8"

  head "https://github.com/vmi/cocot.git"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
