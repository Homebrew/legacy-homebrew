require 'formula'

class Ejabberd <Formula
  url "http://www.process-one.net/downloads/ejabberd/2.1.5/ejabberd-2.1.5.tar.gz"
  homepage 'http://www.ejabberd.im'
  md5 '2029ceca45584d704ca821a771d6d928'

  depends_on "openssl" if MACOS_VERSION < 10.6
  depends_on "erlang"

  def install
    ENV['TARGET_DIR'] = ENV['DESTDIR'] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin

    Dir.chdir "src" do
      args = ["--prefix=#{prefix}",
              "--sysconfdir=#{etc}",
              "--localstatedir=#{var}"]

      if MACOS_VERSION < 10.6
        openssl = Formula.factory('openssl')
        args << "--with-openssl=#{openssl.prefix}"
      end

      system "./configure", *args
      system "make"
      system "make install"
    end

    (etc+"ejabberd").mkpath
    (var+"lib/ejabberd").mkpath
    (var+"spool/ejabberd").mkpath
  end

  def caveats; <<-EOS.undent
    If you face nodedown problems, concat your machine name to:
      /private/etc/hosts
    after 'localhost'.
    EOS
  end
end
