require 'formula'

class UniversalPcre < Requirement
  def message; <<-EOS.undent
    pcre must be build universal for uwsgi to work.
    You will need to:
      brew rm pcre
      brew install --universal pcre
    EOS
  end

  def fatal?
    true
  end

  def satisfied?
    f = Formula.factory('pcre')
    f.installed? && archs_for_command(f.lib/'libpcre.dylib').universal?
  end
end

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.2.6.tar.gz'
  sha1 '61996a4bc7d745dc3ed849c78310c4e1c5c70ee1'

  depends_on UniversalPcre.new
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
