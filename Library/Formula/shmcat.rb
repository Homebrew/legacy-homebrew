class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "http://shmcat.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.7.tar.bz2"
  sha256 "dfe113592425373ea3d67cad5e9e44cbc27e45c75af3b308240aee9530d169cc"

  bottle do
    cellar :any
    sha256 "ab506697c27345d9efe49e21f9631fb1bfc1834cbb7cf2179f698b5f9a71e73a" => :yosemite
    sha256 "32c8493fa69cc202fc49dfde49c0288236666246d42dd3a6e3d6d0c87e6205a1" => :mavericks
    sha256 "736f0bad34d004a83f6c7fed14623ccc2ccb00ae6df2a03325962bf1a647148e" => :mountain_lion
  end

  option "with-ftok", "Build the ftok utility"
  option "with-gettext", "Build with Native Language Support"

  deprecated_option "with-nls" => "with-gettext"

  depends_on "gettext" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-ftok" if build.without? "ftok"

    if build.with? "gettext"
      args << "--with-libintl-prefix=#{Formula["gettext"].opt_include}"
    else
      args << "--disable-nls"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/shmcat --version")
  end
end
