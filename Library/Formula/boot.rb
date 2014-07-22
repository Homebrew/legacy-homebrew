require "formula"

class Boot < Formula

  homepage "https://github.com/tailrecursion/boot"
  url "https://github.com/tailrecursion/boot/archive/1.0.5.tar.gz"
  sha1 "ea4dbbc18bed8ec1023f2a11a2378278f700c521"

  head do
    url "https://github.com/tailrecursion/boot.git"
  end

  depends_on "leiningen"

  resource "jar" do
    url "https://clojars.org/repo/tailrecursion/boot/1.0.5/boot-1.0.5.jar"
    sha1 "da8ab455b81781f44cf8fc0cae52c8f8ac3608fe"
  end

  def install
    if build.head?
      ENV.prepend_path "PATH", Formula["leiningen"].bin
      system "make", "boot"
      bin.install "boot"
    else
      resource("jar").stage { bin.install "boot-1.0.5.jar" => "boot" }
    end
  end

  test do
    (testpath/"build.boot").write <<-EOS.undent
      #!/usr/bin/env boot

      #tailrecursion.boot.core/version "2.5.0"

      (defn -main [& args]
        (println "hello, world!")
        (System/exit 0))
    EOS

    assert_equal "hello, world!", `#{bin}/boot build.boot`.strip
  end
end
