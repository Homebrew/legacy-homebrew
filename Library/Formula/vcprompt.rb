require 'formula'

class Vcprompt < Formula
  homepage 'https://bitbucket.org/gward/vcprompt'
  url 'https://bitbucket.org/gward/vcprompt/downloads/vcprompt-1.2.1.tar.gz'
  sha1 'fb623e6183b8e5ccbbe5cf7d135a04e727c9b402'

  head do
    url 'hg://https://bitbucket.org/gward/vcprompt'
    depends_on :autoconf
  end

  depends_on 'sqlite'

  def install
    system "autoconf" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    system "#{bin}/vcprompt"
  end
end
