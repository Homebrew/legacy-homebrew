class WirouterKeyrec < Formula
  homepage ""
  url "http://tools.salvatorefresta.net/WiRouter_KeyRec_1.1.2.zip"
  version "1.1.2"
  sha1 "3c17f2d0bf3d6201409862fd903ebfd60c1e8a2e"


  def install
  	ENV.deparallelize
    ENV.no_optimization
	
	inreplace "src/agpf.h", /\/etc\/wirouterkeyrec/, "#{prefix}/etc/config"
	inreplace "src/teletu.h", /\/etc\/wirouterkeyrec/, "#{prefix}/etc/config"
	
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{prefix}",
                          "--exec-prefix=#{prefix}"
    system "make prefix=#{prefix}"
    
    (bin).install "build/wirouterkeyrec"
    (prefix/"etc").install "config"
  end

  test do
    
    system "#{bin}/wirouterkeyrec -s Alice-123456"
  end
end
