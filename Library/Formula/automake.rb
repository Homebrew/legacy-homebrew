require 'formula'

class Automake < Formula
  homepage 'http://www.gnu.org/software/automake/'
  url 'http://ftpmirror.gnu.org/automake/automake-1.14.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/automake/automake-1.14.tar.gz'
  sha1 '648f7a3cf8473ff6aa433c7721cab1c7fae8d06c'

  bottle do
    sha1 'd4b453a2c8d0f4c0cefa499a8f658448d781225e' => :mavericks
    sha1 'bbbd4cc22501df3e747596d4bfd02cba987fc852' => :mountain_lion
    sha1 '8ee87f97dc533fd1b86a46dff0b05d831070c6cb' => :lion
  end

  # Always needs a newer autoconf, even on Snow Leopard.
  depends_on 'autoconf' => :run

  if MacOS::Xcode.provides_autotools? or File.file? "/usr/bin/automake"
    keg_only "Xcode (up to and including 4.2) provides (a rather old) Automake."
  end

  def install
    ENV['PERL'] = '/usr/bin/perl'

    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # Our aclocal must go first. See:
    # https://github.com/mxcl/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<-EOS.undent
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  def test
    system "#{bin}/automake", "--version"
  end
end
