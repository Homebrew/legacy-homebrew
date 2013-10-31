require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'https://projects.unbit.it/downloads/uwsgi-1.9.14.tar.gz'
  sha1 '81e89b96f627c2d2c94224c2403cbd09fefa32f0'

  depends_on :python
  depends_on 'pcre'
  depends_on 'libyaml'

  def install
    python do
      %w{CFLAGS LDFLAGS}.each { |e| ENV.append e, "-arch #{MacOS.preferred_arch}" }

      system python, "uwsgiconfig.py", "--build"
      bin.install "uwsgi"
    end
  end
end
