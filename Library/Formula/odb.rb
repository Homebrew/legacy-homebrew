require "formula"

class Odb < Formula
    homepage "http://www.codesynthesis.com/products/odb"
    url "http://www.codesynthesis.com/download/odb/2.3/odb-2.3.0.tar.gz"
    sha1 "53c851e3f3724b72d7c7a74c497c50c195729ad1"

    depends_on 'gcc' => :build
    depends_on 'libcutl' => :build

    patch do
        url "http://codesynthesis.com/~boris/tmp/odb/odb-2.3.0-gcc-4.9.0.patch"
        sha1 "9d0fe9db9d8667c76cd6a1bb15e911560796b656"
    end

    def install
        args = [
            "CC=gcc-4.9",
            "CPP=cpp-4.9",
            "CXX=g++-4.9",
            "CXXFLAGS=-fno-devirtualize"
        ]
        system "./configure", *args
        system "make", "install"
    end

    test do
        system "odb", "--help"
    end

    def caveats; <<-EOS.undent
        ODB is undel GPL v2 or NCUEL.
        Please read http://codesynthesis.com/products/odb/license.xhtml before use.
        EOS
    end
end
