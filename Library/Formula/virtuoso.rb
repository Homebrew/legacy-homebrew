class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "http://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.1/virtuoso-opensource-7.2.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/virtuoso/virtuoso/7.2.1/virtuoso-opensource-7.2.1.tar.gz"
  sha256 "8e680173f975266046cdc33b0949c6c3320b82630288aed778524657a32ee094"

  bottle do
    cellar :any
    sha256 "cf68911a2cf5d7a585cc62d00ffc5821cb53b527785c81fc949c92a1ceb91e1f" => :el_capitan
    sha256 "f3e13eaf6ad4c143d49a14475d82884f24c3dcb5ddf93d5ffb7e6657d4db4917" => :yosemite
    sha256 "c43ed7906276ca762e87b2dee10581db96d41317a6e8027db6987b905f3ca78c" => :mavericks
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", :branch => "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl"

  conflicts_with "unixodbc", :because => "Both install `isql` binaries."

  skip_clean :la

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
