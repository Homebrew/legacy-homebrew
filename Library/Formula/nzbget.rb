require 'formula'

class Nzbget < Formula
  homepage 'http://sourceforge.net/projects/nzbget/'
  url 'https://downloads.sourceforge.net/project/nzbget/nzbget-stable/12.0/nzbget-12.0.tar.gz'
  sha1 'b7f3037ca664f09c28ab359cf6091d876d63ba5f'

  head 'https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      Clang older than 5.1 requires flexible array members to be POD types.
      More recent versions require only that they be trivially destructible.
      EOS
  end

  resource "libpar2" do
    url "https://downloads.sourceforge.net/project/parchive/libpar2/0.2/libpar2-0.2.tar.gz"
    sha1 "4b3da928ea6097a8299aadafa703fc6d59bdfb4b"
  end

  # Bugfixes and ability to cancel par2 repair
  resource "libpar2_patch" do
    url "https://gist.githubusercontent.com/Smenus/4576230/raw/e722f2113195ee9b8ee67c1c424aa3f2085b1066/libpar2-0.2-nzbget.patch"
    sha1 "0dca03f42c0997fd6b537a7dc539d705afb76157"
  end

  def install
    resource("libpar2").stage do
      buildpath.install resource("libpar2_patch")
      system "patch -p1 < #{buildpath}/libpar2-0.2-nzbget.patch"

      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/lp2"
      system "make install"
    end

    # Tell configure where libpar2 is, and tell it to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libpar2-includes=#{libexec}/lp2/include",
                          "--with-libpar2-libraries=#{libexec}/lp2/lib",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.j1
    system "make install"
    system "make install-conf"
  end
end
