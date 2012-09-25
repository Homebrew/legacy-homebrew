require 'formula'

# Official download has untrusted SSL cert, so use Debian

class Minbif < Formula
  homepage 'http://minbif.im/'
  url 'http://ftp.de.debian.org/debian/pool/main/m/minbif/minbif_1.0.3.orig.tar.gz'
  sha1 'ab4f41c6b3777235d816e619f1770d1f9857f7a8'

  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'libpurple'
  depends_on 'imlib2' => :optional
  depends_on 'libcaca' => :optional

  def install
    inreplace "minbif.conf" do |s|
      s.gsub! "users = /var", "users = #{var}"
      s.gsub! "motd = /etc", "motd = #{etc}"
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"

    (var + "lib/minbif/users").mkpath
  end

  def caveats; <<-EOS.undent
    Minbif must be passed its config as first argument:
        minbif #{etc}/minbif/minbif.conf

    Learn more about minbif: http://minbif.im/Quick_start
    EOS
  end
end
