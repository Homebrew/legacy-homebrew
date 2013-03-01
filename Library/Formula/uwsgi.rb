require 'formula'

class UniversalPcre < Requirement
  fatal true

  satisfy :build_env => false do
    f = Formula.factory('pcre')
    f.installed? && archs_for_command(f.lib/'libpcre.dylib').universal?
  end

  def message; <<-EOS.undent
    pcre must be build universal for uwsgi to work.
    You will need to:
      brew rm pcre
      brew install --universal pcre
    EOS
  end
end

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.4.6.tar.gz'
  sha1 '5d1c1a4c4eda56923aae65492f646fbc78fc1297'

  depends_on UniversalPcre
  depends_on 'pcre'

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
