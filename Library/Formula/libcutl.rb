require "formula"
class Libcutl < Formula
    homepage "http://www.codesynthesis.com/products/libcutl"
    url "http://www.codesynthesis.com/download/libcutl/1.8/libcutl-1.8.1.tar.gz"
    sha1 "5411892a2959b6164321ebfb6e8e52255786b143"
    def install
        system "./configure", "--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"
        system "make", "install"
    end
    def caveats; <<-EOS.undent
        libcutl is free, open-source software;
        you can use, distribute, and/or modify it under the terms of the MIT License.
        EOS
    end
end
