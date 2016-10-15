require "formula"

class Libbcrypt < Formula
  homepage "http://openwall.com/crypt/"
  url "http://www.openwall.com/crypt/crypt_blowfish-1.3.tar.gz"
  sha1 "461ba876ebacd5f7dc95f1eb3c5286d6e0983ae0"
  def install
    system "make"
    system "#{ENV.cc} -shared -W1,-soname,libbcrypt.1.3.dylib -o libbcrypt.1.3.dylib crypt_blowfish.o"
    lib.install "libbcrypt.1.3.dylib"
    lib.install_symlink "libbcrypt.1.3.dylib" => "libbcrypt.dylib"
  end
end
