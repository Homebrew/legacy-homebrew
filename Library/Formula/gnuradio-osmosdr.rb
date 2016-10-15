class GnuradioOsmosdr < Formula
    desc "osmocom Gnu Radio Blocks"
    homepage "http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"

    stable do
        url "http://cgit.osmocom.org/gr-osmosdr/snapshot/gr-osmosdr-0.1.4.zip"
        sha256 "a5c439f275cf11965d2fc67957e1d221b4f985ff5d87cdc9760522ba8319215d"
    end

    depends_on "boost"
    depends_on "gnuradio"

    def install
        mkdir "build" do
            system "cmake", "..", *std_cmake_args
            system "make"
            system "make install"
        end
    end
end
