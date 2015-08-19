class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "http://www.nongnu.org/confuse/"
  url "http://savannah.nongnu.org/download/confuse/confuse-2.7.tar.gz"
  sha256 "e32574fd837e950778dac7ade40787dd2259ef8e28acd6ede6847ca895c88778"

  bottle do
    cellar :any
    sha1 "1364f86a7dfa199fee07f273f6e3b4945b9db02a" => :yosemite
    sha1 "d1edb26d0b30a9d85453cf811a5acf582dba3d56" => :mavericks
    sha1 "9ede76f809eb464d96a8f703fb74c1678fc0c48d" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
