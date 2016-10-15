class Gnuradio < Formula
    desc "GNU Radio is a free software development toolkit that provides the signal processing runtime and processing blocks to implement software radios using readily-available, low-cost external RF hardware and commodity processors."
    homepage "https://gnuradio.org/"

    stable do
        url "http://gnuradio.org/releases/gnuradio/gnuradio-3.7.8rc1.tar.gz"
        sha256 "a2228c8cba0194924c7549e37085b5c3837c3282ac96f5bf2392c07cbaed0895"
    end

    resource "Cheetah" do
        url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
        sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
    end

    resource "lxml" do
        url "https://pypi.python.org/packages/source/l/lxml/lxml-2.0.tar.gz"
        sha256 "062e6dbebcbe738eaa6e6298fe38b1ddf355dbe67a9f76c67a79fcef67468c5b"
    end

    option "with-doxygen", "Generate docs for gnuradio using doxygen"
    option "with-python", "Enable wrappers for python"
    option "with-qt", "Enable qt gui"
    option "with-wx", "Enable wxWidgets gui"
    option "with-grc", "Enable GNU Radio Companion"
    option "with-wavelet", "Enable collection of wavelet blocks"
    option "with-audio", "Enable audio subsystems"

    depends_on "cmake" => :build

    depends_on "boost"
    depends_on "cppunit"
    depends_on "fftw"
    depends_on "python" if build.with? "python"
    depends_on "swig" if build.with? "python"
    depends_on "homebrew/python/numpy" if build.with? "python"
    depends_on "gsl" if build.with? "wavelet"
    depends_on "qt4" if build.with? "qt"
    depends_on "qwt" if build.with? "qt"
    depends_on "pyqt" if build.with? "qt"
    depends_on "wxpython" if build.with? "wx"
    depends_on "jack" if build.with? "audio"
    depends_on "portaudio" if build.with? "audio"
    depends_on "doxygen" if build.with? "doxygen"

    depends_on "log4cpp" => :recommended
    depends_on "uhd" => :recommended
    depends_on "sdl" => :recommended
    depends_on "orc" => :optional
    depends_on "thrift" => :optional

    def install
        if build.with? "grc"
            ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
            ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
            install_args = ["setup.py", "install", "--prefix=#{libexec}"]

            resource("Cheetah").stage { system "python", *install_args }
            resource("lxml").stage { system "python", *install_args }
        end

        mkdir "build" do
            system "cmake", "..", *std_cmake_args
            system "make"
            system "make install"
        end
    end
end
