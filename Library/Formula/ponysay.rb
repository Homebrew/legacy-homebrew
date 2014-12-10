require "formula"

class Ponysay < Formula
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.2.tar.gz"
  sha1 "e152b4ffea3dff8d2ca18ab597344e9b50ab78e6"

  bottle do
    sha1 "b84b8b2c6376c9f0dd6cc404dc3089702c14da38" => :mavericks
    sha1 "f4c871b6a3c8d1afcb2c36f83df7237f4c825e9b" => :mountain_lion
    sha1 "ad4531eef91d6dd525d9d38909e11f106b78cfe2" => :lion
  end

  depends_on :python3
  depends_on "coreutils"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end
end
