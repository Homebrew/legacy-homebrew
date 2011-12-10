require 'formula'

class Uwsgi < Formula
  url 'http://projects.unbit.it/downloads/uwsgi-0.9.9.3.tar.gz'
  homepage 'http://projects.unbit.it/uwsgi/'
  md5 'bbf4ac40901fb9d26c8286e7637b77f5'

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    flags = archs.as_arch_flags

    ENV.append 'CFLAGS', flags
    ENV.append 'LDFLAGS', flags

    inreplace 'uwsgiconfig.py', "PYLIB_PATH = ''", "PYLIB_PATH = '#{%x[python-config --ldflags].chomp[/-L(.*?) -l/, 1]}'"

    system "python uwsgiconfig.py --build"
    bin.install "uwsgi"
  end

  def caveats
    <<-EOS.undent
      NOTE: "brew install -v uwsgi" will fail!
      You must install in non-verbose mode for this to succeed.
      Patches to fix this are welcome.
    EOS
  end
end
