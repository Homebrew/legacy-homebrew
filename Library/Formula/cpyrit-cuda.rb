require 'formula'

class CudaRequirement < Requirement
  build true
  fatal true

  satisfy { which 'nvcc' }

  env do
    # Nvidia CUDA installs (externally) into this dir (hard-coded):
    ENV.append 'CFLAGS', "-F/Library/Frameworks"
    # # because nvcc has to be used
    ENV.append 'PATH', which('nvcc').dirname, ':'
  end

  def message
    <<-EOS.undent
      To use this formula with NVIDIA graphics cards you will need to
      download and install the CUDA drivers and tools from nvidia.com.

          https://developer.nvidia.com/cuda-downloads

      Select "Mac OS" as the Operating System and then select the
      'Developer Drivers for MacOS' package.
      You will also need to download and install the 'CUDA Toolkit' package.

      The `nvcc` has to be in your PATH then (which is normally the case).

    EOS
  end
end

class CpyritCuda < Formula
    homepage 'https://code.google.com/p/pyrit/'
    url 'https://pyrit.googlecode.com/files/cpyrit-cuda-0.4.0.tar.gz'
    sha1 '6481b1d104fc8a1753d50d517b99638782171a08'

    depends_on 'libnet' => '--with-python'
    depends_on 'scapy' => :python
    depends_on :python

    def install
      ENV.append 'LDFLAGS', "-L/usr/local/cuda/lib"
      python do
        system python, "setup.py", "build"
        system python, "setup.py", "install", "--prefix=#{prefix}"
      end
    end
    def caveats
      python.standard_caveats if python
    end
end
