require 'formula'

class Chicken < Formula
  homepage 'http://www.call-cc.org/'
  url 'http://code.call-cc.org/releases/4.9.0/chicken-4.9.0.1.tar.gz'
  sha1 'd6ec6eb51c6d69e006cc72939b34855013b8535a'

  head 'git://code.call-cc.org/chicken-core'

  bottle do
    sha1 "18413b340d0dc2486f132dbd3997911d00eb3706" => :mavericks
    sha1 "f29dfe8f310772927022f175d60cb30c7c761b2d" => :mountain_lion
    sha1 "86d71f277efc7b45ae4a1d1b0bcab326f8aafdb1" => :lion
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=macosx
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      POSTINSTALL_PROGRAM=install_name_tool
    ]

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
