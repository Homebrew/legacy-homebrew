class Libqglviewer < Formula
  desc "C++ Qt library to create OpenGL 3D viewers"
  homepage "http://www.libqglviewer.com/"
  url "http://www.libqglviewer.com/src/libQGLViewer-2.6.3.tar.gz"
  sha256 "be611b87bdb8ba794a4d18eaed87f22491ebe198d664359829233c4ea69f4d02"

  head "https://github.com/GillesDebunne/libQGLViewer.git"

  bottle do
    cellar :any
    sha256 "4e10d8f4fc3dd26fdecf2ea84eb7f9d4ce31de6ed0bf32827c5f2c2c3467e3f0" => :el_capitan
    sha256 "e38fbb01b02b961a242b56340cc1d2f3010b64ea21c8c7caf5c20dee077ea505" => :yosemite
    sha256 "0c866f4fb472474fda0054a4fd7b3c54500a2c076e0699179da8d2614ccf94a1" => :mavericks
    sha256 "d43ff135e46f0032759e33c8f42da2c0c306e3c5bdeacb09f79fe082196ece7a" => :mountain_lion
  end

  option :universal

  depends_on "qt"

  def install
    args = %W[
      PREFIX=#{prefix}
      DOC_DIR=#{doc}
    ]
    args << "CONFIG += x86 x86_64" if build.universal?

    cd "QGLViewer" do
      system "qmake", *args
      system "make", "install"
    end
  end
end
