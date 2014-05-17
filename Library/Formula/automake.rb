require 'formula'

class Automake < Formula
  homepage 'http://www.gnu.org/software/automake/'
  url 'http://ftpmirror.gnu.org/automake/automake-1.14.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/automake/automake-1.14.1.tar.gz'
  sha1 '0bb1714b78d70cab9907d2013082978a28f48a46'

  bottle do
    sha1 '8720e073a828e5b7e29e5cacd01b3ccca88a6d40' => :mavericks
    sha1 'ed3cba7f2a806a4192e875e809bb73b65a128757' => :mountain_lion
    sha1 '12d0d7d3b6d31ea4faf9551076225343e9a5af1f' => :lion
  end

  depends_on 'autoconf' => :run

  keg_only :provided_until_xcode43

  def install
    ENV['PERL'] = '/usr/bin/perl'

    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<-EOS.undent
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    system "#{bin}/automake", "--version"
  end
end
