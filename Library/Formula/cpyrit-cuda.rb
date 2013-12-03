require 'formula'

class CpyritCuda < Formula
    homepage 'https://code.google.com/p/pyrit/'
    url 'https://pyrit.googlecode.com/files/cpyrit-cuda-0.4.0.tar.gz'
    sha1 '6481b1d104fc8a1753d50d517b99638782171a08'

    depends_on 'libnet'
    depends_on 'scapy'
    depends_on :python

    def install
      ENV.append 'LDFLAGS', "-L/usr/local/cuda/lib"
      system python, "setup.py", "build"
      system python, "setup.py", "install"
    end
end
