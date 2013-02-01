require 'formula'

class Libpar2 < Formula
  url 'http://sourceforge.net/projects/parchive/files/libpar2/0.2/libpar2-0.2.tar.gz'
  homepage 'http://parchive.sourceforge.net/'
  sha1 '4b3da928ea6097a8299aadafa703fc6d59bdfb4b'

  def initialize; super 'libpar2'; end

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      ./par2fileformat.h:87:25: error: flexible array member 'entries' of non-POD element type 'FILEVERIFICATIONENTRY []'
    EOS
  end

  def patches
    # Patch libpar2 - bugfixes and ability to cancel par2 repair
    "https://gist.github.com/raw/4576230/e722f2113195ee9b8ee67c1c424aa3f2085b1066/libpar2-0.2-nzbget.patch"
  end
end

class Nzbget < Formula
  homepage 'http://sourceforge.net/projects/nzbget/'
  url 'http://downloads.sourceforge.net/project/nzbget/nzbget-stable/9.1/nzbget-9.1.tar.gz'
  sha1 '779258e9349ebc1ea78ae1d7ba5d379af35d4040'
  head 'https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk', :using => :svn

  # Also depends on libxml2 and openssl but the ones in OS X are fine
  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Configure errors out when testing the libpar2 headers because
      Clang does not support flexible arrays of non-POD types.
      EOS
  end

  def install
    # Install libpar2 inside nzbget, nothing else uses it
    libpar2_prefix = libexec/'libpar2'
    Libpar2.new.brew do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{libpar2_prefix}"
      system "make install"
    end

    # Need to add -lcrypto
    ENV["LIBS"] = "-lssl -lcrypto"

    # Tell configure where libpar2 is, and tell it to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-libpar2-includes=#{libpar2_prefix}/include",
                          "--with-libpar2-libraries=#{libpar2_prefix}/lib",
                          "--with-tlslib=OpenSSL", "--prefix=#{prefix}"
    system "make install"
    system "make install-conf"
  end
end
