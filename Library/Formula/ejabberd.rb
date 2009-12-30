require 'formula'

class Ejabberd <Formula
  version "2.1.2"
  url "http://www.process-one.net/downloads/ejabberd/#{version}/ejabberd-#{version}.tar.gz"
  homepage 'http://www.ejabberd.im'
  md5 '9102802ae19312c26f85ceb977b519aa'

  depends_on "erlang"

  def install
    ENV['TARGET_DIR'] = ENV['DESTDIR'] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin

    Dir.chdir "src" do
      system "./configure", "--prefix=#{prefix}",
                            "--sysconfdir=#{etc}",
                            "--localstatedir=#{var}"
      system "make"
      system "make install"
    end

    (etc+"ejabberd").mkpath
    (var+"lib/ejabberd").mkpath
    (var+"spool/ejabberd").mkpath

    sbin.install 'tools/ejabberdctl'
  end

  def caveats; <<-EOS
  If you face nodedown problems, concat your machine name to:
    /private/etc/hosts
  after 'localhost'.
    EOS
  end
end
