class SchemeInstalled < Requirement
  fatal true

  satisfy { which('bigloo') || which('gsi') || which('gosh') ||
            which('guile') || which('kawa') || which('scheme48') ||
            which('scsh') || which('sisc') }

  def message; <<-EOS.undent
    A Scheme implementation is required to use SLIB.

    You can install one of the SLIB supported Scheme
    implementation with Homebrew:
      brew install bigloo
      brew install gambit-scheme
      brew install gauche
      brew install guile
      brew install kawa
      brew install scheme48
      brew install scsh
      brew install sisc-scheme

    Or you can use one of several different prepackaged installers
    that are available.
    EOS
  end
end

class Slib < Formula
  homepage "http://people.csail.mit.edu/jaffer/SLIB"
  url "http://groups.csail.mit.edu/mac/ftpdir/scm/slib-3b4.zip"
  sha1 "dda1ed78ff7164738a1a8c51f1f7c08ec1db79eb"

  depends_on SchemeInstalled

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "infoz", "INSTALL_INFO=install-info"
    system "make", "install", "INSTALL_INFO=install-info"
  end

  test do
    system "#{bin}/slib", "-v"
  end
end
