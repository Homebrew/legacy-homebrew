class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "http://quazip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quazip/quazip/0.7.1/quazip-0.7.1.tar.gz"
  sha256 "78c984103555c51e6f7ef52e3a2128e2beb9896871b2cc4d4dbd4d64bff132de"

  bottle do
    cellar :any
    sha256 "d15a12c624d377bd818458635ad078782659f313c223836f1689ed89cca32a63" => :yosemite
    sha256 "d6ea39c00ad991be78e2b6fdd1d69a5c4079fc85ef6dbdbedab7c8becf77d0c7" => :mavericks
    sha256 "a6a988cb89a12f6e7c2d5bd8ebe180f40b18f586f3bd1e09a6b881350daee637" => :mountain_lion
  end

  depends_on "qt"

  def install
    # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    if ENV.compiler == :clang && MacOS.version >= :mavericks
      spec = "unsupported/macx-clang-libc++"
    else
      spec = "macx-g++"
    end

    args = %W[
      -config release -spec #{spec}
      PREFIX=#{prefix}
      LIBS+=-L/usr/lib LIBS+=-lz
      INCLUDEPATH+=/usr/include
    ]

    system "qmake", "quazip.pro", *args
    system "make", "install"

    cd "qztest" do
      args = %W[-config release -spec #{spec}]
      system "qmake", *args
      system "make"
      bin.install "qztest"
    end
  end

  test do
    system "#{bin}/qztest"
  end
end
