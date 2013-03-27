require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.9.1.tar.gz'
  sha1 '48eb8f9e9d30f816af78f5dbd453781cb96b33ab'

  depends_on 'pcre'
  depends_on 'libyaml'

  def install
    arch = MacOS.prefer_64_bit? ? 'x86_64' : 'i386'
    %w{CFLAGS LDFLAGS}.each { |e| ENV.append e, "-arch #{arch}" }

    system "python", "uwsgiconfig.py", "--build"
    bin.install "uwsgi"
  end
end
