require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/0.98.0/libbson-0.98.0.tar.gz"
  sha1 "3e80019b8896669dc84781fe105438a3ccd2f483"

  bottle do
    cellar :any
    sha1 "d0a43ac2ce476cf7bc20350857786713418c7977" => :mavericks
    sha1 "9fd0d05b79e2cc48811df35dabcc0878c205af55" => :mountain_lion
    sha1 "cfb36772ff29c3aaf00815a372e0e20d9fa3b08c" => :lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
