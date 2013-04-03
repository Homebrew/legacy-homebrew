require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.9.4.tar.gz'
  sha1 'c3d67c6dba32830810506a4552ee4814d0a73a42'

  depends_on 'pcre'
  depends_on 'libyaml'

  def install
    arch = MacOS.prefer_64_bit? ? 'x86_64' : 'i386'
    %w{CFLAGS LDFLAGS}.each { |e| ENV.append e, "-arch #{arch}" }

    system "python", "uwsgiconfig.py", "--build"
    bin.install "uwsgi"
  end
end
