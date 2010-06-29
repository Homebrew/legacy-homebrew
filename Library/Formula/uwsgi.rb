require 'formula'

class Uwsgi <Formula
  url 'http://projects.unbit.it/downloads/uwsgi-0.9.5.3.tar.gz'
  homepage 'http://projects.unbit.it/uwsgi/'
  md5 'f4835859bc87080a58289b980b7ae15c'

  def install
    # Find the archs of the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.delete :ppc7400
    archs.delete :ppc64

    flags = archs.collect{ |a| "-arch #{a}" }.join(' ')

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
