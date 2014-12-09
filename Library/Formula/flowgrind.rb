require 'formula'

class Flowgrind < Formula
  homepage 'https://launchpad.net/flowgrind'
  url 'https://launchpad.net/flowgrind/trunk/flowgrind-0.7.5/+download/flowgrind-0.7.5.tar.bz2'
  sha1 '77cccd3a5111a03153de8278d33430f36ef0a92c'

  depends_on 'gsl'
  depends_on 'xmlrpc-c'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flowgrind", "--version"
  end
end
