require 'formula'

class Web100clt < Formula
  homepage 'http://www.internet2.edu/performance/ndt/'
  url 'http://software.internet2.edu/sources/ndt/ndt-3.6.4.tar.gz'
  sha1 'a83f086cc9fbe802dfd0ff3b6631acf29461b75e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # we only want to build the web100clt client so we need
    # to change to the src directory before installing.
    cd 'src' do
      system "make install"
    end

    cd 'doc' do
      man1.install 'web100clt.man' => 'web100clt.1'
    end
  end

  def test
    system "#{bin}/web100clt", "-v"
  end
end
