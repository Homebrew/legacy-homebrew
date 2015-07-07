require 'formula'

class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage 'http://www.eyrie.org/~eagle/software/remctl/'
  url 'http://archives.eyrie.org/software/kerberos/remctl-3.9.tar.gz'
  sha1 '9fbd9c48e085f521ac68fde8336dce2b839a9054'

  depends_on 'pcre'
  depends_on 'libevent'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
