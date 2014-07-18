require "formula"

class Quazip < Formula
  homepage "http://quazip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quazip/quazip/0.6.2/quazip-0.6.2.tar.gz"
  sha1 "2fdcd063df645f94f047374d7d540b102fc683dc"

  bottle do
    cellar :any
    sha1 "1e61e9506d6f355b8d696e78866784e89e595e5b" => :mavericks
    sha1 "6cdaaa01521a0659b580f7e0099472fe0285b7a7" => :mountain_lion
    sha1 "e180385f38e14945a97472f5b44fffeea9924cdd" => :lion
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
