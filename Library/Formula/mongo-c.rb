require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://github.com/mongodb/mongo-c-driver/archive/v0.8.zip'
  sha1 'f21924cea0011ad71309f86f1358d082d855aa79'

  # Reported upstream:
  # https://github.com/mxcl/homebrew/pull/22096
  def patches
    "https://gist.github.com/planas/6321873/raw"
  end

  def install
    system "make"
    system "make", "install", "DESTDIR=", "PREFIX=#{prefix}"
  end
end
