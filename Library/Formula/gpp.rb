require 'formula'

class Gpp < Formula
  homepage 'http://en.nothingisreal.com/wiki/GPP'
  url 'http://files.nothingisreal.com/software/gpp/gpp-2.24.tar.bz2'
  sha1 '4d79bc151bd16f45494b3719d401d670c4e9d0a4'

  bottle do
    cellar :any
    sha1 "94fbc6d6c17cc299e9b583d72000bde67e931d49" => :mavericks
    sha1 "0391db6ff96c79077aec04cd3ea6dbbfedbcc977" => :mountain_lion
    sha1 "706df4f172e242d6a69ecafb14bb27bd97113077" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make check"
    system "make install"
  end
end
