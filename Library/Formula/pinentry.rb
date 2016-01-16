class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://gnupg.org/ftp/gcrypt/pinentry/pinentry-0.9.7.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.7.tar.bz2"
  sha256 "6398208394972bbf897c3325780195584682a0d0c164ca5a0da35b93b1e4e7b2"

  bottle do
    cellar :any
    revision 1
    sha256 "def02b22eaf6952407f037a3923f44b5e1ed8a94cfd208134c1799258200e877" => :el_capitan
    sha256 "e859990def70e26bf7e3b26732b7b73154ae209659161671713702e294cd0b06" => :yosemite
    sha256 "00152cec104d9c9e515ba5c0b29aa942161fac38225317d66514b822e2e5617f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "gtk+" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-gnome3
    ]

    args << "--disable-pinentry-gtk2" if build.without? "gtk+"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end
