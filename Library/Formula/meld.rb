require 'formula'

class Meld < Formula
  homepage 'http://meldmerge.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/meld/1.8/meld-1.8.2.tar.xz'
  sha1 'da6e4430ea3e56ec649b53f96c485de13a52627f'

  depends_on 'intltool' => :build
  depends_on 'xz' => :build
  depends_on :x11
  depends_on :python
  depends_on 'pygtk'
  depends_on 'pygtksourceview'
  depends_on 'pygobject'
  depends_on 'rarian'

  # TODO: Move this into Library/Homebrew somewhere (see also mitmproxy.rb and ansible.rb).
  def wrap bin_file, pythonpath
    bin_file = Pathname.new bin_file
    libexec_bin = Pathname.new libexec/'bin'
    libexec_bin.mkpath
    mv bin_file, libexec_bin
    bin_file.write <<-EOS.undent
    #!/bin/sh
    PYTHONPATH="#{pythonpath}:$PYTHONPATH" "#{libexec_bin}/#{bin_file.basename}" "$@" > /dev/null 2>&1
    EOS
  end

  def install
    system "make", "prefix=#{prefix}", "install"

    Dir["#{bin}/*"].each do |bin_file|
      wrap bin_file, python.global_site_packages
    end
  end
end
