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
    url "https://github.com/kfogel/OneTime/archive/2.0-beta2.tar.gz"
    version "2.0.02"
    sha1 "2dbfe3f6479aed6c9e76337dd27b063ff73967fa"
  end

  def install
    # inreplace required for now due to upstream issue:
    # https://github.com/kfogel/OneTime/issues/11
    inreplace "Makefile", "$(DESTDIR)/usr/bin/", "$(DESTDIR)#{bin}"
    mkdir bin
    system "make", "install"
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
