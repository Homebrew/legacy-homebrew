class Uhd < Formula
    desc "The USRP Hardware Driver™ software (UHD™) is the hardware driver for all USRP devices. It works on all major platforms (Linux, Windows, and Mac) and can be built with GCC, Clang, and MSVC compilers."
    homepage "http://files.ettus.com/manual/"

    stable do
        url "https://github.com/EttusResearch/uhd/archive/release_003_008_005.zip"
        sha256 "c62715c6967068bb090dfbfc5eda830bfe8a6b51b6de1dad10d318fd73b52ee9"
    end

    resource "Cheetah" do
        url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
        sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
    end

    depends_on "cmake" => :build
    depends_on "boost"
    depends_on "libusb"
    depends_on "python"
    depends_on "doxygen"

    def install
        ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
        ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
        install_args = ["setup.py", "install", "--prefix=#{libexec}"]

        resource("Cheetah").stage { system "python", *install_args }

        chdir "host"
        mkdir "build" do
            system "cmake", "..", *std_cmake_args
            system "make"
            system "make", "test"
            system "make install"
        end
    end
end
