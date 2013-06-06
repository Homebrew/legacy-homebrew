require 'formula'

class Sshtrix < Formula
  homepage 'http://www.nullsecurity.net/tools/cracker.html'
  url 'http://www.nullsecurity.net/tools/cracker/sshtrix-0.0.2.tar.gz'
  sha1 '6ac43099d5c399459ae705bafc9d12fec9e6ac4a'

  depends_on 'libssh'

  def install
    bin.mkpath
    system "make", "sshtrix", "CC=#{ENV.cc}"
    system "make", "DISTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/sshtrix", "-V"
    system "#{bin}/sshtrix", "-O"
  end
end
