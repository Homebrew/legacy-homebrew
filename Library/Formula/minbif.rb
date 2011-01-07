require 'formula'

class Minbif <Formula
  url 'http://minbif.im/attachments/download/50/minbif-1.0.3.tar.gz'
  homepage 'http://minbif.im/'
  md5 'c08add6234a6dd4a45b46b590fa63268'

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
