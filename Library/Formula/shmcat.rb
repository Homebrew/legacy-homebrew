class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "http://shmcat.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.7.tar.bz2"
  sha256 "dfe113592425373ea3d67cad5e9e44cbc27e45c75af3b308240aee9530d169cc"

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
