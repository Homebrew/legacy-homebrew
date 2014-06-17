require 'formula'

class Bro < Formula
  homepage 'http://www.bro-ids.org/'
  url 'http://www.bro-ids.org/downloads/release/bro-2.3.tar.gz'
  sha1 '79397be0e351165d44047b044d29b5e6580532cc'

  bottle do
    sha1 "8aa75265faa2f23b73f7b27b7e495d79c60447d7" => :mavericks
    sha1 "322c30d872bfe4271d113f8c54fad4fd7476f899" => :mountain_lion
    sha1 "cf5fe821b85cfac5d8e4ebd86df37a7c75cf95cc" => :lion
  end

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on 'geoip' => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
