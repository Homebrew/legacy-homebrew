class Gnuradio < Formula
  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "http://gnuradio.squarespace.com/"
  url "http://gnuradio.org/releases/gnuradio/gnuradio-3.7.8.1.tar.gz"
  sha256 "8406f49d085fdc2ef5d8ea90f3e19ad8782d2a2f5154bbe4f076591ddf7ae5aa"

  bottle do
    sha256 "5968cb5c61c7f44cb3b8c66c6ca418949d34c633f181ddcea78c5e1656b5a34a" => :yosemite
    sha256 "7fedd78a538330c8f48afd5caab61e25c39c484e45458099d0bf6d133c800e7a" => :mavericks
    sha256 "09e37da8c6acd59adb657be9f1b638ae005d522f47524b26c2653682d60bfae7" => :mountain_lion
  end

  # These python extension modules were linked directly to a Python
  # framework binary.
  # Replace -lpython with -undefined dynamic_lookup in linker flags.
  # https://github.com/gnuradio/gnuradio/pull/604
  patch do
    url "https://github.com/gnuradio/gnuradio/pull/604.patch"
    sha256 "9e1c612f0f4063d387d85517cc420f050f49c7903d36fab45b72e8d828549e3c"
  end

  option "without-python", "Build without python support"
  option "with-documentation", "Build with documentation"
  option :universal

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "boost"
  depends_on "cppunit"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "zeromq"

  if build.with? "python"
    depends_on "swig" => :build
    depends_on "pygtk"
    depends_on "wxpython"
    depends_on "qt"
    depends_on "qwt"
    depends_on "pyqt"
  end

  if build.with? "documentation"
    depends_on "doxygen" => :build
    depends_on "sphinx-doc" => :build
  end

  depends_on "uhd" => :recommended
  depends_on "sdl" => :recommended
  depends_on "jack" => :recommended
  depends_on "portaudio" => :recommended

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.10.1.tar.gz"
    sha256 "8b9f453f29ce96a14e625100d3dcf8926301d36c5f622623bf8820e748510858"
  end

  # cheetah starts here
  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.tar.gz"
    sha256 "b8370fce4fbcd6b68b6b36c0fb0f4ec24d6ba37ea22988740f4701536611f1ae"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end
  # cheetah ends here

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-2.0.tar.gz"
    sha256 "062e6dbebcbe738eaa6e6298fe38b1ddf355dbe67a9f76c67a79fcef67468c5b"
  end

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/raw/a4459abdd1d70fd980f9c166d73da71fe9762e0b/zmq.hpp"
    sha256 "f042d4d66e2a58bd951a3eaf108303e862fad2975693bebf493931df9cd251a5"
  end

  def install
    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    res = %w[Markdown Cheetah lxml numpy]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("cppzmq").stage include.to_s

    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DENABLE_DEFAULT=OFF"
    enabled_components = %w[gr-analog gr-fft volk gr-filter gnuradio-runtime
                            gr-blocks testing gr-pager gr-noaa gr-channels
                            gr-audio gr-fcd gr-vocoder gr-fec gr-digital
                            gr-dtv gr-atsc gr-trellis gr-zeromq]
    enabled_components << "gr-wavelet"
    enabled_components << "gr-video-sdl" if build.with? "sdl"
    enabled_components << "gr-uhd" if build.with? "uhd"
    enabled_components += %w[python gr-ctrlport grc gr-utils gr-qtgui gr-wxgui] if build.with? "python"
    enabled_components += %w[doxygen sphinx] if build.with? "documentation"

    enabled_components.each do |c|
      args << "-DENABLE_#{c.upcase.split("-").join("_")}=ON"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Remove useless data files installed in #{bin}
    delete_files = %w[ctrlport-monitorc ctrlport-monitoro perf-monitorxc perf-monitorxo]
    delete_files.each { |f| rm "#{bin}/gr-#{f}" }

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnuradio-config-info -v").chomp
  end
end
