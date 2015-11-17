class Gnuradio < Formula
  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "http://gnuradio.squarespace.com/"
  url "http://gnuradio.org/releases/gnuradio/gnuradio-3.7.8.tar.gz"
  sha256 "fe19cb54b5d77fb76dde61d5cf184c6dee7066779b45c51676bae6e6d0cd4172"

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
  depends_on "doxygen" => :build if build.with? "documentation"

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

  depends_on "uhd" => :recommended
  depends_on "sdl" => :recommended
  depends_on "jack" => :recommended
  depends_on "portaudio" => :recommended

  resource "numpy" do
    url "https://downloads.sourceforge.net/project/numpy/NumPy/1.10.0b1/numpy-1.10.0b1.tar.gz"
    sha256 "855695405092686264dc8ce7b3f5c939a6cf1a5639833e841a5bb6fb799cd6a8"
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

  # sphinx starts here
  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "alabaster" do
    url "https://pypi.python.org/packages/source/a/alabaster/alabaster-0.7.3.tar.gz"
    sha256 "0703c1ea5a6af0bb6d0cec24708301334949d56ebc7f95c64028d9c66f9d8d5d"
  end

  resource "babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-1.3.tar.gz"
    sha256 "9f02d0357184de1f093c10012b52e7454a1008be6a5c185ab7a3307aceb1d12e"
  end

  resource "snowballstemmer" do
    url "https://pypi.python.org/packages/source/s/snowballstemmer/snowballstemmer-1.2.0.tar.gz"
    sha256 "6d54f350e7a0e48903a4e3b6b2cabd1b43e23765fbc975065402893692954191"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.2.tar.bz2"
    sha256 "3e15b416c9a2039c1a51208b2cd3bb4ffd796cd19e601b1d2657afcb77c3dc90"
  end

  resource "sphinx_rtd_theme" do
    url "https://pypi.python.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-0.1.7.tar.gz"
    sha256 "9a490c861f6cf96a0050c29a92d5d1e01eda02ae6f50760ad5c96a327cdf14e8"
  end

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.3.1.tar.gz"
    sha256 "1a6e5130c2b42d2de301693c299f78cc4bd3501e78b610c08e45efc70e2b5114"
  end
  # sphinx ends here

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/raw/34c8e4395c94d34a89bbeaaf2b8f9c94a8293c84/zmq.hpp"
    sha256 "6cdd9d920f4a0f9f3a3257541321bef8369d9735c88b84ba8ae0e461f53e476c"
  end

  def install
    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_path "PATH", libexec/"vendor/bin" if build.with? "documentation"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    res = %w[Markdown Cheetah lxml numpy]
    res << %w[sphinx sphinx_rtd_theme alabaster babel docutils pygments
              jinja2 markupsafe snowballstemmer six pytz] if build.with? "documentation"
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
