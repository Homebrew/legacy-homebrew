class Malaga < Formula
  desc "Grammar development environment for natural languages"
  homepage "http://home.arcor.de/bjoern-beutel/malaga/"
  url "http://home.arcor.de/bjoern-beutel/malaga/malaga-7.12.tgz"
  sha256 "8811e5feaae03e1b6e3008116fdc7471a53b6c0c5036751c637b15058f855ace"

  bottle do
    cellar :any
    sha1 "21c26733bf8c4d31017cbd751717777432004af3" => :mavericks
    sha1 "c7c3e9cb7aba63a2746f1acf5c274749a846928d" => :mountain_lion
    sha1 "3f93dd5b8ab479471e20e05c9a617ddb8a8e298d" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
