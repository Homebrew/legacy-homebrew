class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "http://ftpmirror.gnu.org/findutils/findutils-4.4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/findutils/findutils-4.4.2.tar.gz"
  sha256 "434f32d171cbc0a5e72cfc5372c6fc4cb0e681f8dce566a0de5b6fccd702b62a"

  bottle do
    revision 1
    sha1 "2f98c4a6352ba11092a3e90cab5670e4e1b95e07" => :yosemite
    sha1 "93a1389d8a4124a8f36832484dd0232ac7bf99c7" => :mavericks
    sha1 "60134ccc215dd1216bfb256a1d38dd58c74525de" => :mountain_lion
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}/locate",
            "--disable-dependency-tracking",
            "--disable-debug"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gfind", "--version"
  end
end
