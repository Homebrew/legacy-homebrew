class Gqrx < Formula
    desc "Gqrx is a software defined radio receiver powered by the GNU Radio SDR framework and the Qt graphical toolkit."
    homepage "http://gqrx.dk"

    stable do
        url "https://github.com/csete/gqrx/archive/v2.3.2.zip"
        sha256 "d73eaea350eaa01e0d160a973ceb82d61fa3e1acf78d3f13ffba6bcfe649add5"
    end

    depends_on "qt"
    depends_on "gnuradio"
    depends_on "gnuradio-osmosdr"

    def install
        system "qmake", "PREFIX=#{prefix}"
        system "make"
        system "make install"
        prefix.install "#{prefix}/bin/Gqrx.app"
    end
end
