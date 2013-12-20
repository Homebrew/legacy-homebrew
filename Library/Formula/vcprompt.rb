require 'formula'

class Vcprompt < Formula
  homepage 'https://bitbucket.org/gward/vcprompt'
  url 'https://bitbucket.org/gward/vcprompt/downloads/vcprompt-1.2.tar.gz'
  sha1 '5e46cc8525f823ecd66c624903f15f5c50276290'

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
