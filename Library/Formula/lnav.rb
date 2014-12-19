require 'formula'

class Lnav < Formula
  homepage 'http://lnav.org'
  url 'https://github.com/tstack/lnav/releases/download/v0.7.1/lnav-0.7.1.tar.gz'
  sha1 'c7ba019afd40742437211e4173e2a19f8971eb7f'

  head 'https://github.com/tstack/lnav.git'

  bottle do
    sha1 "34a53eb6606660c29fa1cdadb6a45af811ff7ae1" => :yosemite
    sha1 "57e96d8f6d40a01d1e6aa31b4b7ae0d738fb30fb" => :mavericks
    sha1 "884bd4be97c7d778e2c619d6e71d95d1cc1d7663" => :mountain_lion
  end

  depends_on 'readline'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
