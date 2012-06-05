require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.1.2.tar.gz'
  md5 '69d2a89e283a047c750dde858a384e25'

  skip_clean :all # stripping breaks the executable

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    arch_flags = archs.as_arch_flags

    ENV.append 'CFLAGS', arch_flags
    ENV.append 'LDFLAGS', arch_flags

    system "python", "uwsgiconfig.py", "--build"
    bin.install "uwsgi"
  end
end
