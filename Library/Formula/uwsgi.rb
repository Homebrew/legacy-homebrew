require 'formula'

class UniversalPcre < Requirement
  fatal true

  satisfy :build_env => false do
    pcre = Formula.factory('pcre')
    pcre.installed? && archs_for_command(pcre.lib/'libpcre.dylib').universal?

    libyaml = Formula.factory('libyaml')
    libyaml.installed? && archs_for_command(libyaml.lib/'libyaml.dylib').universal?
  end

  def message; <<-EOS.undent
    pcre and libyaml must be build universal for uwsgi to work.
    You will need to:
      brew rm pcre && brew install --universal pcre
      brew rm libyaml && brew install --universal libyaml
    EOS
  end
end

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.4.8.tar.gz'
  sha1 '476f8c474c021f0c91160309c41ad601ca2f824b'

  depends_on UniversalPcre
  depends_on 'pcre'
  depends_on 'libyaml'

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
