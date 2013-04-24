require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.9.7.tar.gz'
  sha1 '735a25963398a696f6814aea21a40f93a3a69ce0'

  depends_on 'pcre'
  depends_on 'libyaml'

  def install
    arch = MacOS.prefer_64_bit? ? 'x86_64' : 'i386'
    %w{CFLAGS LDFLAGS}.each { |e| ENV.append e, "-arch #{arch}" }

    system "python", "uwsgiconfig.py", "--build"
    bin.install "uwsgi"
  end
end
