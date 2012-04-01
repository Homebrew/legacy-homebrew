require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.0.4.tar.gz'
  md5 '559c8d1fa8274fb45437c277c0c7f121'

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    flags = archs.as_arch_flags

    ENV.append 'CFLAGS', flags
    ENV.append 'LDFLAGS', flags

    system "python uwsgiconfig.py --build"
    bin.install "uwsgi"
  end
end
