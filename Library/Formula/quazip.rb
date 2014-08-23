require "formula"

class Quazip < Formula
  homepage "http://quazip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quazip/quazip/0.7/quazip-0.7.tar.gz"
  sha1 "861ab4efc048fdb272161848bb8829848857ec97"

  bottle do
    cellar :any
    sha1 "446a5af6f7cd0d9d480d1ffe935866cebeacea81" => :mavericks
    sha1 "0558adc8641a1e9a76f2555914a08b5ed1495a13" => :mountain_lion
    sha1 "2a622f7b99eee61883bbcf5eedc755d34f73730a" => :lion
  end

  depends_on "qt"

  def install
    # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    if ENV.compiler == :clang and MacOS.version >= :mavericks
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
