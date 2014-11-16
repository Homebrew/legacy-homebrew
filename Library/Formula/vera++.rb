require "formula"

class Veraxx < Formula
  homepage "https://bitbucket.org/verateam/vera"
  url "https://bitbucket.org/verateam/vera/downloads/vera++-1.2.1.tar.gz"
  sha1 "0bf7d463dabe41c2069dbe2fa4f7fca192cb7d6e"

  depends_on "cmake" => :build
  depends_on "boost"

  # Use prebuilt docs to avoid need for pandoc
  resource "doc" do
    url "https://bitbucket.org/verateam/vera/downloads/vera++-1.2.1-doc.tar.gz"
    sha1 "fce30676c815b99aa66d25c9dfbd2eda2c74bd7a"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"

    resource("doc").stage do
      man1.install "vera++.1"
      doc.install "vera++.html"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/vera++ --version").strip
  end
end
