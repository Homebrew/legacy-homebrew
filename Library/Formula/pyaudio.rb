require 'formula'

class Pyaudio < Formula
  url 'http://people.csail.mit.edu/hubert/pyaudio/packages/pyaudio-0.2.4.tar.gz'
  homepage 'http://people.csail.mit.edu/hubert/pyaudio/'
  md5 '623809778f3d70254a25492bae63b575'

  depends_on 'portaudio'

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    ENV['ARCHFLAGS'] = archs.as_arch_flags

    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end
