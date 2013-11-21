require 'formula'

class Fwknop < Formula
  homepage 'http://www.cipherdyne.org/fwknop/'
  url 'https://github.com/mrash/fwknop/archive/2.5.1-1.tar.gz'
  version '2.5.1-1'
  sha1 '3f6c43b91ab555d7652b81c16bccfc8049eb0f92'

  head 'https://github.com/mrash/fwknop.git'

  # needed for running autogen.sh script in GitHub release tarball
  # as well as when building from HEAD
  depends_on :automake
  depends_on :autoconf
  depends_on :libtool

  # needed for gpg support
  depends_on 'gpgme' => :optional

  def install
    system './autogen.sh' if build.head? or !File.exists?('configure')
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fwknop", "--version"
  end
end
