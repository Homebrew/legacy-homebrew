class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "http://ftpmirror.gnu.org/findutils/findutils-4.4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/findutils/findutils-4.4.2.tar.gz"
  sha256 "434f32d171cbc0a5e72cfc5372c6fc4cb0e681f8dce566a0de5b6fccd702b62a"

  bottle do
    revision 1
    sha256 "27dfbb29443811ccac8ed9062dd251ce565de7383449ab18d16d0e6461a951c3" => :el_capitan
    sha256 "4d65d83123ae350e3a4e79f61f3a5d6e797dd6cda434db3c61a7f86ecda9bf09" => :yosemite
    sha256 "52b6ad3ccde5c2a56d56e7a08fb297be2651c5e6998500d85cbecab43842b692" => :mavericks
    sha256 "1ad71a6f373f31e2b3b71c3de67b8e7cf0bcb9d16339846f0efa2709aef91c7b" => :mountain_lion
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}/locate",
            "--disable-dependency-tracking",
            "--disable-debug",
           ]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    if build.with? "default-names"
      system "#{bin}/find", "."
    else
      system "#{bin}/gfind", "."
    end
  end
end
