require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'https://projects.unbit.it/downloads/uwsgi-1.9.11.tar.gz'
  sha1 '2b3d4f225808decb50399b9cdb387e022dd3729d'

  depends_on 'pcre'
  depends_on 'libyaml'

  def install
    arch = MacOS.prefer_64_bit? ? 'x86_64' : 'i386'
    %w{CFLAGS LDFLAGS}.each { |e| ENV.append e, "-arch #{arch}" }

    system "python", "uwsgiconfig.py", "--build"
    bin.install "uwsgi"
  end
end
