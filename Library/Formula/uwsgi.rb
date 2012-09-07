require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.2.5.tar.gz'
  sha1 'd34ab260883416553aa186027cfbc23f38efdc6f'

  depends_on 'pcre' # needs a universal build

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
