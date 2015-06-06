class QtGstreamer < Formula
  desc "C++ bindings for GStreamer with a Qt-style API"
  homepage "http://gstreamer.freedesktop.org/modules/qt-gstreamer.html"
  url "http://gstreamer.freedesktop.org/src/qt-gstreamer/qt-gstreamer-1.2.0.tar.xz"
  sha256 "9f3b492b74cad9be918e4c4db96df48dab9c012f2ae5667f438b64a4d92e8fd4"
  head "git://anongit.freedesktop.org/gstreamer/qt-gstreamer"

  depends_on "cmake" => :build
  depends_on "gstreamer"
  depends_on "glib"
  depends_on "gst-plugins-base"
  depends_on "boost"
  depends_on "doxygen" => [:optional, :build]
  depends_on "qt5"

  def install
    args = []
    args << "-DQT_VERSION:STRING=5"
    # the library needs to be installed in gstreamers plugin dir. change it, so
    # that it is in the right place after sym-linking.
    # This only partly correct. The path from gstreamer would be correct, but
    # there is no (easy) way of getting it, so hardcoding it is.
    args << "-DGSTREAMER_PLUGIN_DIR:PATH=#{lib}/gstreamer-1.0"

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    system "gst-launch-1.0", "videotestsrc", "num-buffers=1", "!", "qt5videosink"
  end
end
