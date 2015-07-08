require "formula"

class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  head "https://github.com/bro/bro.git"

  stable do
    url "https://www.bro.org/downloads/release/bro-2.4.tar.gz"
    sha256 "740c0d0b0bec279c2acef5e1b6b4d0016c57cd02a729f5e2924ae4a922e208b2"

  end

  bottle do
    sha256 "6ebeb99f7435427fea693cb6a7a1484cbf065a501af389ff6a86b139a16a7cbe" => :yosemite
    sha256 "6a15212763d47074a8d9cc3783a0e28c245eebc79afc09b4f86d385840a8e07a" => :mavericks
    sha256 "b1ab1064cba21febae1e902477292a974602881ad4d2aa837ed1ee008df0eaf3" => :mountain_lion
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
