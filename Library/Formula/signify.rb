require "formula"

class Signify < Formula
  homepage "http://www.tedunangst.com/flak/post/signify"
  url "https://github.com/nurse/signify.git", :tag => "v0.0.1"
  sha1 "3522a7024dda0960ad06d7825757d457680c3758"

    depends_on "autoconf" => :build

  head do
    url "https://github.com/nurse/signify.git"
  end

  def install
    system "autoreconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # try to create a new signature without a passphrase
    system "signify -n -G -p newkey.pub -s newkey.sec"
  end
end
