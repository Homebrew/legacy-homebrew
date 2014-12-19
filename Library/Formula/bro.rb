require "formula"

class Bro < Formula
  homepage "https://www.bro.org"
  head "https://github.com/bro/bro.git"

  stable do
    url "https://www.bro.org/downloads/release/bro-2.3.1.tar.gz"
    sha256 "ff32d21e335d2ddb3e2942527c3212de6ead4e7ffd6ac958497fa80e04e60800"

    # Fix for ntohll errrors on Yosemite. Already in HEAD.
    patch do
      url "https://github.com/bro/bro/commit/121fcdbb5b9221.diff"
      sha1 "985cede121964a96fe10c81f2239d1f0c137c517"
    end
  end

  bottle do
    sha1 "19d44e396ea474a01625333cc005d59c15a1a779" => :yosemite
    sha1 "3ec9e7b7c05b68668f6559322372a2f57344f735" => :mavericks
    sha1 "6e69354144ece0c4b99fe0c8f07c353e5892bf3c" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "geoip" => :recommended
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
