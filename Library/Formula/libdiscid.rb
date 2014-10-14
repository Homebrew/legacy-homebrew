require 'formula'

class Libdiscid < Formula
  homepage 'http://musicbrainz.org/doc/libdiscid'
  url 'http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz'
  sha1 '4e682d24bceeb35c19800f9141348d77eae133f2'

  bottle do
    cellar :any
    sha1 "95bf200795a497d67a574a18d60bf0ac5a1e5d58" => :mavericks
    sha1 "b923aa0f9b34463a7be0cfbf1a3c2a582a39a035" => :mountain_lion
    sha1 "3c582b75f88f6d2cf3aa3c2bd78a3467a9b099af" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
