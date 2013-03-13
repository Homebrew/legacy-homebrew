require 'formula'

class Uwsgi < Formula
  homepage 'http://projects.unbit.it/uwsgi/'
  url 'http://projects.unbit.it/downloads/uwsgi-1.4.8.tar.gz'
  sha1 '476f8c474c021f0c91160309c41ad601ca2f824b'

  depends_on 'pcre'
  depends_on 'libyaml'

  def install
    arch = MacOS.prefer_64_bit? ? 'x86_64' : 'i386'
    %w{CFLAGS LDFLAGS}.each { |e| ENV.append e, "-arch #{arch}" }

    system "python", "uwsgiconfig.py", "--build"
    bin.install "uwsgi"
  end
end
