require 'formula'

class Openssl < Formula
  url 'http://www.openssl.org/source/openssl-0.9.8r.tar.gz'
  version '0.9.8r'
  homepage 'http://www.openssl.org'
  md5 '0352932ea863bc02b056cda7c9ac5b79'

  keg_only :provided_by_osx,
    "The OpenSSL provided by Leopard (0.9.7) is too old for some software."

  def install
    system "./config", "--prefix=#{prefix}",
                       "--openssldir=#{etc}",
                       "zlib-dynamic", "shared"

    inreplace 'Makefile' do |s|
      s.change_make_var! 'MANDIR', man
    end

    ENV.j1 # Parallel compilation fails
    system "make"
    system "make test"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Note that the libraries built tend to be 32-bit only, even on Snow Leopard.
    EOS
  end
end
