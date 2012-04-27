require 'formula'

class Php < Formula
  homepage 'http://www.php.net/'
  url 'http://museum.php.net/php5/php-5.2.17.tar.gz'
  md5 '04d321d5aeb9d3a051233dbd24220ef1'

  depends_on 'gettext'
  depends_on 'libmcrypt'
  depends_on 'mhash'
  depends_on 't1lib'
  depends_on 'jpeg'
  depends_on 'gd'
  depends_on 'libtool'
  depends_on 'aspell' => ['--lang=en']
  depends_on 'openssl'
  depends_on 'wget'
  depends_on 'gmp'
  depends_on 're2c'
  depends_on 'mysql'
  depends_on 'imap-uw'
  
  def options 
	  [
		['--setup-sql', 'Do first time setup for Mysql'],
		['--fix-path', 'Appends .bashrc to load /usr/local/bin before /usr/bin']
	  ]
  end
  
  def install
    ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize
    
    #system "MACOSX_DEPLOYMENT_TARGET=10.7"
	#system "CFLAGS=\"$CFLAGS -O3 -fomit-frame-pointer\""
    #system "EXTRA_LIBS=\"-lresolv -liconv\""
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=/private/etc",
                          "--localstatedir=/var", "--with-config-file-path=/etc",
                          "--with-openssl", "--with-zlib", "--enable-bcmath", "--with-curl",
                          "--enable-exif", "--with-gd", "--with-jpeg-dir", "--with-png-dir=/usr/X11",
                          "--enable-gd-native-ttf", "--with-t1lib",
                          "--with-mcrypt", "--with-mhash",
                          "--with-gettext=/usr/local/Cellar/gettext/0.18.1.1", "--with-iconv",
                          "--enable-mbstring", "--enable-mbregex", "--with-mysql=/usr/local",
                          "--with-mysqli=/usr/local/bin/mysql_config",
                          "--enable-sockets", "--with-pspell", "--disable-pdo", "--without-sqlite",
                          "--enable-soap", "--with-xsl", "--with-xmlrpc", "--with-imap", 
                          "--with-imap-ssl", "--with-kerberos", "--with-gmp",
                          "--with-apxs2=/usr/sbin/apxs", "--enable-pcntl", "--mandir=#{man}"
	system "make -j3"
	
	if File.exists? "usr/libexec/apache2/libphp5.so"
		puts "Ensuring apache module permissions are correct"
		system "sudo chown #{ENV['USER']} /usr/libexec/apache2/libphp5.so" unless File.writable? '/usr/libexec/apache2/libphp5.so'
	end
		
    system "make install" 
    
    if ARGV.include? '--setup-sql'
    	if File.exists? "#{ENV['HOME']}/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    		system "launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    		FileUtils.rm("#{ENV['HOME']}/Library/LaunchAgents/homebrew.mxcl.mysql.plist")
    	end
		system "ln -s `brew --prefix mysql`/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
		system "launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    end
    
    if ARGV.include? '--fix-path'
    	open("#{ENV['HOME']}/.bashrc", 'a') do |f|
    		f.puts "PATH=/usr/local/bin:$PATH\n"
    		f.puts "export PATH"
    	end
    end
    
    puts "Restarting apache"
    system "sudo apachectl restart"
    	
  end
  
  def patches
  	# Sevence rounding patch
  	{:p0 => ["https://gist.github.com/raw/2505235/15c6be7a302a7f421516e993b6be969735b695e6/patch-ext-gmp-tmp.c.diff",
			"https://gist.github.com/raw/2505235/2a84d86f80aafd08ba38a842f54fbbce0f19a6c1/patch-ext-standard-basic_functions.c.diff",
  			"https://gist.github.com/raw/2505235/db74e8bcb0bbf23ef6235be6def24a871496a139/patch-ext-standard-formatted_print.c.diff",
  			"https://gist.github.com/raw/2505235/4dc79bf96e92d72852ce49d011cef92fa88ba74c/patch-ext-standard-info.c.diff",
  			"https://gist.github.com/raw/2505235/cc03d36ada89d91843494a8ab48222db12c3721e/patch-ext-standard-math.c.diff",
  			"https://gist.github.com/raw/2505235/31d558a3656e26a0a4c035259a947db850bc3a1d/patch-ext-standard-php_math.h.diff",
  			"https://gist.github.com/raw/2505235/d7cab77906097418a08029831dd265a558b20e5a/patch-sapi-cli-php_cli.c.diff",
  			"https://gist.github.com/raw/2505235/143568f10dc1d6ebe2b3d560dca8ce6b93a60bdf/patch-Zend-Zend.m4.diff",
  			"https://gist.github.com/raw/2505235/2db8fab93881ee741ed5f4b7b331b3276c384ad0/patch-Zend-zend_operators.c.diff",
  			"https://gist.github.com/raw/2505235/33e2699fa840aa0e34708ad3a23c67168655d8d6/patch-Zend-zend_strtod.h.diff"]}
  end
  
  def caveats
  	puts "Check to make sure you're not using the old plist in launchctl -- launchctl list | grep sql"
  end

  def test
    system "php"
  end
end
