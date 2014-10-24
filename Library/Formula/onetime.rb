require "formula"

class Onetime < Formula
  homepage "http://red-bean.com/onetime/"
  url "http://red-bean.com/onetime/onetime-1.81.tar.gz"
  sha1 "db8f84963ed7b5831fdf4c19b4494cf7bfd5b753"

  bottle do
    cellar :any
    sha1 "efecf649c941cde0917e4660db0ba460f2193554" => :mavericks
    sha1 "ec09cda341e360b493e28cf05b2ef847caafd90d" => :mountain_lion
    sha1 "b243466379b50a72945aaa124405a5e350dc9203" => :lion
  end

  devel do
    url "http://red-bean.com/onetime/onetime-2.0-beta3.tar.gz"
    version "2.0.03"
    sha1 "db488e9c1463bc4d4b8905546137e15f4fa864e2"
  end

  # Fixes the Makefile to permit destination specification
  # https://github.com/kfogel/OneTime/pull/12
  patch do
    url "https://github.com/kfogel/OneTime/pull/12.diff"
    sha1 "24c3d023c13b556bb34f28909a6ce455f641504c"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "dd", "if=/dev/random", "of=pad_data.txt", "bs=1024", "count=1"
    (testpath+'input.txt').write "INPUT"
    system "#{bin}/onetime", "-e", "--pad=pad_data.txt", "--no-trace",
                             "--config=.", "input.txt"
    system "#{bin}/onetime", "-d", "--pad=pad_data.txt", "--no-trace",
                             "--config=.", "input.txt.onetime"
  end
end
