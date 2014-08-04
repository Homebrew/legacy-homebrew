require 'formula'

class Pinentry < Formula
  homepage 'http://www.gnupg.org/related_software/pinentry/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.8.3.tar.bz2'
  sha1 'fc0efe5d375568f90ddbb23ee68e173411a49d4a'

  bottle do
    cellar :any
    sha1 "806d0a9cef81951318d9fa1fc11cb51479f441d8" => :mavericks
    sha1 "bf58da608d9564e9c20c23a639b3c9ac251b4442" => :mountain_lion
    sha1 "45bbcf616cbf8d853315da9a6dac10c056250201" => :lion
  end

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-pinentry-qt",
                          "--disable-pinentry-qt4",
                          "--disable-pinentry-gtk",
                          "--disable-pinentry-gtk2"
    system "make install"
  end
end
