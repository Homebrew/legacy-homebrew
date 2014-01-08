require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.9.18.2.tar.gz'
  sha1 '613328a2da84a7eb3b6f01f892833f2ef8e591ca'

  depends_on 'pcre'
  depends_on 'libyaml'

  def install
    %w{CFLAGS LDFLAGS}.each { |e| ENV.append e, "-arch #{MacOS.preferred_arch}" }

    system "python", "uwsgiconfig.py", "--build"
    bin.install "uwsgi"
  end
end
