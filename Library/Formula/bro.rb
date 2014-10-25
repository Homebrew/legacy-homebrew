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
    sha1 "8aa75265faa2f23b73f7b27b7e495d79c60447d7" => :mavericks
    sha1 "322c30d872bfe4271d113f8c54fad4fd7476f899" => :mountain_lion
    sha1 "cf5fe821b85cfac5d8e4ebd86df37a7c75cf95cc" => :lion
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
