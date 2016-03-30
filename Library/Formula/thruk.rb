class Thruk < Formula
  desc "Monitoring web interface with support for multiple backends."
  homepage "http://www.thruk.org/"
  url "https://github.com/sni/Thruk/archive/v2.06.tar.gz"
  sha256 "85cd8d44a296887ab3245bfb2d988f4dfe4922f6d85848b05d6d5a5867a8c3d1"

  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "cpanminus"      => :build
  depends_on "libtool"    => :build
  depends_on "nagios"     => :recommended
  depends_on "pkg-config" => :build

  patch :DATA

  private

  def perl_modules
    (%w[Plack-1.tar.gz Plack::Util FCGI GD-2.44.tar.gz Template Date::Manip] +
     %w[Excel::Template Log::Log4perl-1.34.tar.gz Log::Dispatch::File MIME::Lite] +
     %w[LWP::Protocol::connect DBD::mysql HTML::Escape HTML::Lint File::BOM Test::Cmd] +
     %w[Test::Perl::Critic Test::Pod::Coverage Perl::Critic::Policy::Dynamic::NoIndirect] +
     %w[Perl::Critic::Policy::NamingConventions::ProhibitMixedCaseSubs] +
     %w[Perl::Critic::Policy::ValuesAndExpressions::ProhibitAccessOfPrivateData] +
     %w[Perl::Critic::Policy::Modules::ProhibitPOSIXimport WWW::Mechanize::Firefox] +
     %w[Test::JavaScript Test::Vars Devel::Cycle]).join(" ").freeze
  end

  public

  def install
    system "cpanm", "--quiet", "--installdeps", "--self-contained", perl_modules
    system "./configure", "--prefix=#{prefix}",
                          "--with-logdir=#{prefix}/var/log"
    system "perl", "Makefile.PL"
    system "make", "install"
  end

  test do
    system "#{bin}/nagexp", "--version"
    system "#{bin}/naglint", "--version"
    system "#{bin}/thruk", "--version"
  end
end

__END__
diff --git a/script/append.make b/script/append.make
index 1ec97cd..4052164 100644
--- a/script/append.make
+++ b/script/append.make
@@ -60,21 +60,21 @@ local_patches:
 	cp -rp support/*.patch                      blib/replace
 	cp -rp support/thruk_cookie_auth_vhost.conf blib/replace
 	cp -rp support/thruk_cookie_auth.include    blib/replace
-	sed -i blib/replace/* -e 's+@SYSCONFDIR@+${SYSCONFDIR}+g'
-	sed -i blib/replace/* -e 's+@DATADIR@+${DATADIR}+g'
-	sed -i blib/replace/* -e 's+@LOGDIR@+${LOGDIR}+g'
-	sed -i blib/replace/* -e 's+@TMPDIR@+${TMPDIR}+g'
-	sed -i blib/replace/* -e 's+@LOCALSTATEDIR@+${LOCALSTATEDIR}+g'
-	sed -i blib/replace/* -e 's+@BINDIR@+${BINDIR}+g'
-	sed -i blib/replace/* -e 's+@INITDIR@+${INITDIR}+g'
-	sed -i blib/replace/* -e 's+@LIBDIR@+${LIBDIR}+g'
-	sed -i blib/replace/* -e 's+@CHECKRESULTDIR@+${CHECKRESULTDIR}+g'
-	sed -i blib/replace/* -e 's+@THRUKLIBS@+${THRUKLIBS}+g'
-	sed -i blib/replace/* -e 's+@THRUKUSER@+${THRUKUSER}+g'
-	sed -i blib/replace/* -e 's+@THRUKGROUP@+${THRUKGROUP}+g'
-	sed -i blib/replace/* -e 's+@HTMLURL@+${HTMLURL}+g'
-	sed -i blib/replace/* -e 's+@HTTPDCONF@+${HTTPDCONF}+g'
-	sed -i blib/replace/* -e 's+log4perl.conf.example+log4perl.conf+g'
+	sed -i'' -e 's+@SYSCONFDIR@+${SYSCONFDIR}+g' blib/replace/*
+	sed -i'' -e 's+@DATADIR@+${DATADIR}+g' blib/replace/*
+	sed -i'' -e 's+@LOGDIR@+${LOGDIR}+g' blib/replace/*
+	sed -i'' -e 's+@TMPDIR@+${TMPDIR}+g' blib/replace/*
+	sed -i'' -e 's+@LOCALSTATEDIR@+${LOCALSTATEDIR}+g' blib/replace/*
+	sed -i'' -e 's+@BINDIR@+${BINDIR}+g' blib/replace/*
+	sed -i'' -e 's+@INITDIR@+${INITDIR}+g' blib/replace/*
+	sed -i'' -e 's+@LIBDIR@+${LIBDIR}+g' blib/replace/*
+	sed -i'' -e 's+@CHECKRESULTDIR@+${CHECKRESULTDIR}+g' blib/replace/*
+	sed -i'' -e 's+@THRUKLIBS@+${THRUKLIBS}+g' blib/replace/*
+	sed -i'' -e 's+@THRUKUSER@+${THRUKUSER}+g' blib/replace/*
+	sed -i'' -e 's+@THRUKGROUP@+${THRUKGROUP}+g' blib/replace/*
+	sed -i'' -e 's+@HTMLURL@+${HTMLURL}+g' blib/replace/*
+	sed -i'' -e 's+@HTTPDCONF@+${HTTPDCONF}+g' blib/replace/*
+	sed -i'' -e 's+log4perl.conf.example+log4perl.conf+g' blib/replace/*
 
 local_install: local_patches
 	mkdir -p ${DESTDIR}${TMPDIR}
@@ -91,7 +91,7 @@ local_install: local_patches
 	echo "do '${DATADIR}/menu.conf';" > ${DESTDIR}${SYSCONFDIR}/menu_local.conf
 	cp -p support/thruk_local.conf.example ${DESTDIR}${SYSCONFDIR}/thruk_local.conf
 	cp -p cgi.cfg ${DESTDIR}${SYSCONFDIR}/cgi.cfg
-	sed -e 's/^default_user_name=.*$$/default_user_name=/' -i ${DESTDIR}${SYSCONFDIR}/cgi.cfg
+	sed -i'' -e 's/^default_user_name=.*$$/default_user_name=/' ${DESTDIR}${SYSCONFDIR}/cgi.cfg
 	cp -p log4perl.conf.example ${DESTDIR}${SYSCONFDIR}/log4perl.conf
 	cp -p support/naglint.conf.example ${DESTDIR}${SYSCONFDIR}/naglint.conf
 	cp -p support/htpasswd ${DESTDIR}${SYSCONFDIR}/htpasswd
@@ -108,7 +108,7 @@ local_install: local_patches
 	mkdir -p ${DESTDIR}${DATADIR}/themes
 	mkdir -p ${DESTDIR}${DATADIR}/script
 	cp -rp lib root templates ${DESTDIR}${DATADIR}/
-	rm -f ${DESTDIR}${DATADIR}/root/thruk/themes
+	rm -fr ${DESTDIR}${DATADIR}/root/thruk/themes
 	mkdir -p ${DESTDIR}${SYSCONFDIR}/usercontent/
 	rm -rf ${DESTDIR}${DATADIR}/root/thruk/usercontent
 	ln -fs ${SYSCONFDIR}/usercontent ${DESTDIR}${DATADIR}/root/thruk/
