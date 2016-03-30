class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "http://illest.net/libmonome/"
  url "https://github.com/monome/libmonome/releases/download/v1.4.0/libmonome-1.4.0.tar.bz2"
  sha256 "0a04ae4b882ea290f3578bcba8e181c7a3b333b35b3c2410407126d5418d149a"

  head "https://github.com/monome/libmonome.git"

  bottle do
    sha256 "b6553b4ce4d56cca44493acd9615cc399d5e20b6acb403a36914a0df5151926e" => :el_capitan
    sha256 "0c730849c05d8899a6e4bd0f1c3bfdeb791de8fd5d8b10d5c29800b68a2a0906" => :yosemite
    sha256 "b79cc0774b4c270336b57092741d4387feea8d60484be10c0fef7c2af61c65f1" => :mavericks
  end

  depends_on "liblo"

  def install
    inreplace "wscript", "-Werror", ""
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
