require 'formula'

class CiscoDecrypt < Formula
  homepage 'https://www.unix-ag.uni-kl.de/~massar/bin/cisco-decode'
  url 'https://www.unix-ag.uni-kl.de/~massar/soft/cisco-decrypt.c'
  sha1 '7a1f1024686c970290d78afe01217a258735a668'
  version '1.0.0'

  depends_on 'libgcrypt'
  depends_on 'libgpg-error'

  def install
    system "#{ENV.cc} -Wall -o cisco-decrypt cisco-decrypt.c $(libgcrypt-config --libs --cflags)"
    bin.install('cisco-decrypt')
  end
end
