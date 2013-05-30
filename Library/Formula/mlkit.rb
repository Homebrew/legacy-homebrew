require 'formula'

class StandardHomebrewLocation < Requirement
  satisfy HOMEBREW_PREFIX.to_s == "/usr/local"

  def message; <<-EOS.undent
    mlton won't work outside of /usr/local

    Because this uses pre-compiled binaries, it will not work if
    Homebrew is installed somewhere other than /usr/local; mlton
    will be unable to find GMP.
    EOS
  end
end

class Mlkit < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/mlkit'
  url 'http://sourceforge.net/projects/mlkit/files/mlkit-4.3.7/mlkit-4.3.7.tgz'
  sha1 '7c1f69f0cde271f50776d33b194699b403bab598'

  depends_on StandardHomebrewLocation
  depends_on :autoconf => :build
  depends_on 'mlton' => :build
  depends_on :tex
  depends_on 'gmp'

  def install
    system "./autobuild; true"
    system "./configure", "--prefix=#{prefix}"
    ENV.m32
    system "make mlkit"
    system "make mlkit_libs"
    system "make install"
  end

  test do
    system "#{bin}/mlkit", "-V"
  end
end
